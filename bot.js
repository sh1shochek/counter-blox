require("dotenv").config();

const {
    Client, GatewayIntentBits, EmbedBuilder, PermissionsBitField,
    REST, Routes, SlashCommandBuilder, ButtonBuilder, ButtonStyle,
    ActionRowBuilder, ModalBuilder, TextInputBuilder, TextInputStyle,
    AttachmentBuilder, MessageFlags, ChannelType
} = require("discord.js");

const fs     = require("fs");
const crypto = require("crypto");
const { loadDB, saveDB, getKey, setKey, deleteKey, getCFG, setCFG } = require("./db");


// ============================================================
// Локализация
// ============================================================
const STRINGS = {
    ru: {
        already_verified:    "✅ Ты уже верифицирован!",
        code_sent:           "📬 Код отправлен в ЛС!",
        dm_disabled:         "❌ Не могу написать в ЛС! Разреши личные сообщения.",
        no_active_code:      "❌ Нет активного кода. Нажми **Verify me** снова.",
        code_expired:        "❌ Код истёк! Нажми **Verify me** снова.",
        wrong_code:          "❌ Неверный код! Попробуй снова.",
        too_many_attempts:   "❌ Слишком много попыток! Запроси новый код.",
        rate_limited:        "⏳ Код уже отправлен! Подожди немного.",
        verified:            "✅ Верифицирован!",
        welcome:             (name) => `Добро пожаловать на **${name}**!`,
        role_error:          (msg) => `❌ Ошибка при выдаче роли: \`${msg}\`. Обратись к администратору.`,
        dm_title:            "🔐 Код верификации",
        dm_desc:             (name, code) => `**${name}**\n\n**Код:** \`${code}\`\n\nНажми кнопку ниже и введи код.\n⏰ Истекает через **5 минут**.`,
        enter_btn:           "✏️  Ввести код",
        modal_title:         "Верификация",
        modal_label:         "Введи 6-значный код:",
        not_whitelisted:     "У тебя нет ключа. Обратись к администратору.",
    },
    en: {
        already_verified:    "✅ You are already verified!",
        code_sent:           "📬 Check your DMs! Code has been sent.",
        dm_disabled:         "❌ I can't DM you! Enable DMs from server members.",
        no_active_code:      "❌ No active code. Click **Verify me** again.",
        code_expired:        "❌ Code expired! Click **Verify me** again.",
        wrong_code:          "❌ Wrong code! Try again.",
        too_many_attempts:   "❌ Too many attempts! Request a new code.",
        rate_limited:        "⏳ Code already sent! Please wait.",
        verified:            "✅ Verified!",
        welcome:             (name) => `Welcome to **${name}**!`,
        role_error:          (msg) => `❌ Error giving role: \`${msg}\`. Contact an admin.`,
        dm_title:            "🔐 Verification Code",
        dm_desc:             (name, code) => `**${name}**\n\n**Code:** \`${code}\`\n\nClick the button below and enter the code.\n⏰ Expires in **5 minutes**.`,
        enter_btn:           "✏️  Enter code",
        modal_title:         "Verification",
        modal_label:         "Enter 6-digit code:",
        not_whitelisted:     "You don't have a key. Contact admin.",
    }
};

function t(locale, key, ...args) {
    const lang = (locale && locale.startsWith("ru")) ? "ru" : "en";
    const s = STRINGS[lang][key];
    return typeof s === "function" ? s(...args) : s;
}


// ============================================================
// Helpers
// ============================================================
const C = {
    key:  0xB0B0D1,
    ok:   0x50DC64,
    err:  0xFF4444,
    warn: 0xFFAA00,
    log:  0x2B2D31,
    del:  0xFF6060,
    add:  0x60FF90
};

const em = (title, desc, color = C.key) =>
    new EmbedBuilder().setTitle(title).setDescription(desc).setColor(color).setTimestamp();

const keyExpStr = (e) =>
    !e ? "♾️ Lifetime" : Date.now() > e ? "⚠️ Expired" : `<t:${Math.floor(e / 1000)}:F>`;

const genCode = () => Math.floor(100000 + Math.random() * 900000).toString();

async function logTo(guild, channelKey, embed) {
    try {
        const cfg = await getCFG(guild.id);
        const ch  = cfg[channelKey] && guild.channels.cache.get(cfg[channelKey]);
        if (ch) await ch.send({ embeds: [embed] });
    } catch (e) {}
}


// ============================================================
// Slash commands
// ============================================================
const commands = [
    new SlashCommandBuilder()
        .setName("setup")
        .setDescription("Setup bot — creates log channels and category")
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("setverify")
        .setDescription("Send verification message to a channel")
        .addChannelOption(o => o.setName("channel").setDescription("Channel to send verification").setRequired(true))
        .addRoleOption(o => o.setName("role").setDescription("Role to give after verification").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("genkey")
        .setDescription("Generate a license key")
        .addStringOption(o => o.setName("duration").setDescription("Key duration").setRequired(true)
            .addChoices(
                { name: "♾️ Lifetime", value: "lifetime" },
                { name: "📅 Custom days", value: "custom" }
            ))
        .addIntegerOption(o => o.setName("days").setDescription("Days (only if Custom days selected)").setRequired(false).setMinValue(1))
        .addUserOption(o => o.setName("user").setDescription("Assign and DM user").setRequired(false))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("keyinfo")
        .setDescription("Get key info")
        .addStringOption(o => o.setName("key").setDescription("License key").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("bankey")
        .setDescription("Ban a key")
        .addStringOption(o => o.setName("key").setDescription("License key").setRequired(true))
        .addStringOption(o => o.setName("reason").setDescription("Reason").setRequired(false))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("unbankey")
        .setDescription("Unban a key")
        .addStringOption(o => o.setName("key").setDescription("License key").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("resethwid")
        .setDescription("Reset HWID for a key")
        .addStringOption(o => o.setName("key").setDescription("License key").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("deletekey")
        .setDescription("Delete a key permanently")
        .addStringOption(o => o.setName("key").setDescription("License key").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("listkeys")
        .setDescription("List all keys")
        .addStringOption(o => o.setName("filter").setDescription("Filter").setRequired(false)
            .addChoices(
                { name: "All",     value: "all"     },
                { name: "Active",  value: "active"  },
                { name: "Banned",  value: "banned"  },
                { name: "Expired", value: "expired" },
                { name: "Unused",  value: "unused"  }
            ))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("extendkey")
        .setDescription("Extend key expiry")
        .addStringOption(o => o.setName("key").setDescription("License key").setRequired(true))
        .addIntegerOption(o => o.setName("days").setDescription("Days to add").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("stats")
        .setDescription("Key statistics")
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("checkkey")
        .setDescription("Check your key status")
        .addStringOption(o => o.setName("key").setDescription("Your key").setRequired(true)),

    new SlashCommandBuilder()
        .setName("whitelist")
        .setDescription("Add user to whitelist (create key for them)")
        .addUserOption(o => o.setName("user").setDescription("Discord user").setRequired(true))
        .addIntegerOption(o => o.setName("days").setDescription("Days (empty = lifetime)").setRequired(false))
        .addStringOption(o => o.setName("note").setDescription("Note").setRequired(false))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("blacklist")
        .setDescription("Blacklist a user by Discord ID")
        .addStringOption(o => o.setName("userid").setDescription("Discord user ID").setRequired(true))
        .addStringOption(o => o.setName("reason").setDescription("Reason").setRequired(false))
        .addIntegerOption(o => o.setName("days").setDescription("Days (empty = permanent)").setRequired(false))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("unblacklist")
        .setDescription("Remove blacklist from user")
        .addStringOption(o => o.setName("userid").setDescription("Discord user ID").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("getstats")
        .setDescription("Get stats for a Discord user")
        .addStringOption(o => o.setName("userid").setDescription("Discord user ID").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("setnote")
        .setDescription("Set note for a user")
        .addStringOption(o => o.setName("userid").setDescription("Discord user ID").setRequired(true))
        .addStringOption(o => o.setName("note").setDescription("Note text").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("erase")
        .setDescription("Completely remove user from database")
        .addStringOption(o => o.setName("userid").setDescription("Discord user ID").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("compensate")
        .setDescription("Add days to ALL active users")
        .addIntegerOption(o => o.setName("days").setDescription("Days to add").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("generatekeys")
        .setDescription("Generate multiple redeem keys (sends as file)")
        .addIntegerOption(o => o.setName("count").setDescription("How many keys").setRequired(true).setMinValue(1).setMaxValue(100))
        .addStringOption(o => o.setName("duration").setDescription("Key duration").setRequired(true)
            .addChoices(
                { name: "♾️ Lifetime", value: "lifetime" },
                { name: "📅 Custom days", value: "custom" }
            ))
        .addIntegerOption(o => o.setName("days").setDescription("Days (only if Custom days selected)").setRequired(false).setMinValue(1))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("panel")
        .setDescription("Send buyer panel to this channel")
        .setDefaultMemberPermissions(PermissionsBitField.Flags.ManageGuild),

    new SlashCommandBuilder()
        .setName("setunverified")
        .setDescription("Set role to give when member joins (unverified role)")
        .addRoleOption(o => o.setName("role").setDescription("Role to give on join").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("setbuyer")
        .setDescription("Set the buyer role for panel Get Role button")
        .addRoleOption(o => o.setName("role").setDescription("Buyer role").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("setsupport")
        .setDescription("Set support role that can see all tickets")
        .addRoleOption(o => o.setName("role").setDescription("Support role").setRequired(true))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),

    new SlashCommandBuilder()
        .setName("settickets")
        .setDescription("Send ticket creation panel to a channel")
        .addChannelOption(o => o.setName("channel").setDescription("Channel to send panel").setRequired(true).addChannelTypes(ChannelType.GuildText))
        .addChannelOption(o => o.setName("category").setDescription("Category for ticket channels").setRequired(true).addChannelTypes(ChannelType.GuildCategory))
        .setDefaultMemberPermissions(PermissionsBitField.Flags.Administrator),
].map(c => c.toJSON());


// ============================================================
// Bot client
// ============================================================
const bot = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.GuildMembers,
        GatewayIntentBits.MessageContent,
    ]
});

async function registerCommands() {
    const rest = new REST({ version: "10" }).setToken(process.env.DISCORD_TOKEN);
    try {
        // Глобальные команды
        await rest.put(Routes.applicationCommands(process.env.CLIENT_ID), { body: commands });
        console.log("✅ Global commands registered");

        // Гильд-команды (мгновенно)
        for (const [, guild] of bot.guilds.cache) {
            try {
                await rest.put(
                    Routes.applicationGuildCommands(process.env.CLIENT_ID, guild.id),
                    { body: commands }
                );
                console.log(`✅ Guild commands registered for: ${guild.name}`);
            } catch (e) {
                console.error(`❌ Failed for guild ${guild.name}:`, e.message);
            }
        }
    } catch (e) {
        console.error("❌ Failed to register commands:", e.message);
    }
}

bot.once("clientReady", async () => {
    console.log(`🤖 Online: ${bot.user.tag}`);
    bot.user.setActivity("🔑 frost.vip | /setup");
    await registerCommands();
});


// ============================================================
// Member join / leave / edit / role logs
// ============================================================
bot.on("guildMemberAdd", async (member) => {
    // Выдаём роль "unverified" при входе
    try {
        const cfg = await getCFG(member.guild.id);
        if (cfg.unverified_role) {
            const role = member.guild.roles.cache.get(cfg.unverified_role);
            if (role) await member.roles.add(role);
        }
    } catch (e) {
        console.error("guildMemberAdd role error:", e.message);
    }

    await logTo(member.guild, "ch_join_logs", em(
        "➕ Member Joined",
        `**User:** ${member.user} (${member.user.id})\n**Account age:** <t:${Math.floor(member.user.createdTimestamp / 1000)}:R>\n**Members:** ${member.guild.memberCount}`,
        C.add
    ));
});

bot.on("guildMemberRemove", async (member) => {
    await logTo(member.guild, "ch_join_logs", em(
        "➖ Member Left",
        `**User:** ${member.user} (${member.user.id})\n**Members:** ${member.guild.memberCount}`,
        C.del
    ));
});

bot.on("messageDelete", async (msg) => {
    if (!msg.guild || msg.author?.bot) return;
    await logTo(msg.guild, "ch_message_logs", em(
        "🗑️ Message Deleted",
        `**Author:** ${msg.author} (${msg.author?.id})\n**Channel:** ${msg.channel}\n**Content:**\n${msg.content ? "```\n" + msg.content.slice(0, 900) + "\n```" : "*attachment/empty*"}`,
        C.del
    ));
});

bot.on("messageUpdate", async (oldMsg, newMsg) => {
    if (!newMsg.guild || newMsg.author?.bot || oldMsg.content === newMsg.content) return;
    await logTo(newMsg.guild, "ch_message_logs", em(
        "✏️ Message Edited",
        `**Author:** ${newMsg.author}\n**Channel:** ${newMsg.channel}\n**Before:**\n\`\`\`\n${(oldMsg.content || "*empty*").slice(0, 400)}\n\`\`\`\n**After:**\n\`\`\`\n${(newMsg.content || "*empty*").slice(0, 400)}\n\`\`\``,
        C.warn
    ));
});

bot.on("guildMemberUpdate", async (oldMember, newMember) => {
    const added   = newMember.roles.cache.filter(r => !oldMember.roles.cache.has(r.id));
    const removed = oldMember.roles.cache.filter(r => !newMember.roles.cache.has(r.id));
    if (added.size)   await logTo(newMember.guild, "ch_role_logs", em("🎭 Role Added",   `**User:** ${newMember.user}\n**Roles:** ${added.map(r => r).join(", ")}`, C.add));
    if (removed.size) await logTo(newMember.guild, "ch_role_logs", em("🎭 Role Removed", `**User:** ${newMember.user}\n**Roles:** ${removed.map(r => r).join(", ")}`, C.del));
});


// ============================================================
// Single interactionCreate — buttons, modals, slash commands
// ============================================================
bot.on("interactionCreate", async (interaction) => {
    try {
        // ----------------------------------------------------------------
        // BUTTONS
        // ----------------------------------------------------------------
        if (interaction.isButton()) {
            const { customId, user, guild } = interaction;

            // ---- verify_btn ----
            if (customId === "verify_btn") {
                const loc    = interaction.locale;
                const cfg    = await getCFG(guild.id);
                const roleId = cfg.verify_role;
                const member = interaction.member;

                if (roleId && member.roles.cache.has(roleId)) {
                    return interaction.reply({ content: t(loc, "already_verified"), flags: MessageFlags.Ephemeral });
                }

                // Rate limit
                const existing = await getKey("verif_" + user.id);
                if (existing && Date.now() < existing.expires) {
                    return interaction.reply({ content: t(loc, "rate_limited"), flags: MessageFlags.Ephemeral });
                }

                const code    = genCode();
                const expires = Date.now() + 5 * 60 * 1000;

                await setKey("verif_" + user.id, { code, guildId: guild.id, roleId, expires, locale: loc, attempts: 0 });

                try {
                    const enterBtn = new ButtonBuilder()
                        .setCustomId("enter_code")
                        .setLabel(t(loc, "enter_btn"))
                        .setStyle(ButtonStyle.Primary);

                    await user.send({
                        embeds: [em(
                            t(loc, "dm_title"),
                            t(loc, "dm_desc", guild.name, code),
                            0xB0B0D1
                        )],
                        components: [new ActionRowBuilder().addComponents(enterBtn)]
                    });
                    return interaction.reply({ content: t(loc, "code_sent"), flags: MessageFlags.Ephemeral });
                } catch (e) {
                    return interaction.reply({ content: t(loc, "dm_disabled"), flags: MessageFlags.Ephemeral });
                }
            }

            // ---- enter_code ----
            if (customId === "enter_code") {
                const pending = await getKey("verif_" + user.id);
                if (!pending) {
                    return interaction.reply({ content: t(interaction.locale, "no_active_code"), flags: MessageFlags.Ephemeral });
                }
                if (Date.now() > pending.expires) {
                    await deleteKey("verif_" + user.id);
                    return interaction.reply({ content: t(interaction.locale, "code_expired"), flags: MessageFlags.Ephemeral });
                }

                const loc = pending.locale || interaction.locale;

                const modal = new ModalBuilder()
                    .setCustomId("verify_modal")
                    .setTitle(t(loc, "modal_title"));

                modal.addComponents(new ActionRowBuilder().addComponents(
                    new TextInputBuilder()
                        .setCustomId("code_input")
                        .setLabel(t(loc, "modal_label"))
                        .setStyle(TextInputStyle.Short)
                        .setMinLength(6)
                        .setMaxLength(6)
                        .setPlaceholder("123456")
                        .setRequired(true)
                ));
                return interaction.showModal(modal);
            }

            // ---- panel_redeemkey ----
            if (customId === "panel_redeemkey") {
                const modal = new ModalBuilder()
                    .setCustomId("redeem_modal")
                    .setTitle("Redeem Key");
                modal.addComponents(new ActionRowBuilder().addComponents(
                    new TextInputBuilder()
                        .setCustomId("redeem_input")
                        .setLabel("Enter your license key:")
                        .setStyle(TextInputStyle.Short)
                        .setPlaceholder("frost-XXXXXX-XXXXXX-XXXX")
                        .setRequired(true)
                ));
                return interaction.showModal(modal);
            }

            // ---- panel_getscript ----
            if (customId === "panel_getscript") {
                const db    = await loadDB();
                const entry = Object.entries(db).find(([, e]) => e.discordId === user.id);
                if (!entry) {
                    return interaction.reply({ embeds: [em("❌ Not whitelisted", t(interaction.locale, "not_whitelisted"), C.err)], flags: MessageFlags.Ephemeral });
                }
                const [key, e] = entry;
                if (e.banned) return interaction.reply({ embeds: [em("🔨 Blacklisted", e.banReason || "You are blacklisted.", C.err)], flags: MessageFlags.Ephemeral });
                if (e.expires && Date.now() > e.expires) return interaction.reply({ embeds: [em("⏰ Expired", "Your key has expired.", C.err)], flags: MessageFlags.Ephemeral });
                return interaction.reply({
                    embeds: [em(
                        "📜 Your Script",
                        `Paste this in your executor:\n\`\`\`lua\nlocal script_key = "${key}"\nloadstring(game:HttpGet("YOUR_LOADER_URL"))()\n\`\`\`\n**Key expires:** ${keyExpStr(e.expires)}`,
                        C.key
                    )],
                    flags: MessageFlags.Ephemeral
                });
            }

            // ---- panel_getrole ----
            if (customId === "panel_getrole") {
                const cfg = await getCFG(guild.id);
                if (!cfg.buyer_role) {
                    return interaction.reply({ embeds: [em("❌ Error", "Buyer role not configured. Ask admin to use `/setbuyer`.", C.err)], flags: MessageFlags.Ephemeral });
                }
                const role = guild.roles.cache.get(cfg.buyer_role);
                if (!role) {
                    return interaction.reply({ embeds: [em("❌ Error", "Buyer role not found in server.", C.err)], flags: MessageFlags.Ephemeral });
                }

                // Проверка иерархии
                const botMember = guild.members.cache.get(bot.user.id) || await guild.members.fetch(bot.user.id);
                if (role.position >= botMember.roles.highest.position) {
                    return interaction.reply({
                        embeds: [em("❌ Role Too High",
                            `The role ${role} is **above** the bot's highest role.\n\n` +
                            `**Fix:** Move the bot's role **above** "${role.name}" in Server Settings → Roles.\n\n` +
                            "Or move the buyer role below the bot.",
                            C.err
                        )],
                        flags: MessageFlags.Ephemeral
                    });
                }
                if (!botMember.permissions.has(PermissionsBitField.Flags.ManageRoles)) {
                    return interaction.reply({ embeds: [em("❌ No Permission", "Bot is missing **Manage Roles** permission. Contact admin.", C.err)], flags: MessageFlags.Ephemeral });
                }

                const db = await loadDB();
                const entry = Object.entries(db).find(([, e]) => e.discordId === user.id);
                if (!entry) {
                    return interaction.reply({ embeds: [em("❌ Not whitelisted", t(interaction.locale, "not_whitelisted"), C.err)], flags: MessageFlags.Ephemeral });
                }
                if (interaction.member.roles.cache.has(role.id)) {
                    return interaction.reply({ embeds: [em("✅ Already have", `You already have ${role}!`, C.ok)], flags: MessageFlags.Ephemeral });
                }
                try {
                    await interaction.member.roles.add(role);
                    return interaction.reply({ embeds: [em("✅ Role Given", `You got ${role}!`, C.ok)], flags: MessageFlags.Ephemeral });
                } catch (err) {
                    return interaction.reply({ embeds: [em("❌ Error", `Failed to give role: \`${err.message}\``, C.err)], flags: MessageFlags.Ephemeral });
                }
            }

            // ---- panel_resethwid ----
            if (customId === "panel_resethwid") {
                const db    = await loadDB();
                const entry = Object.entries(db).find(([, e]) => e.discordId === user.id);
                if (!entry) {
                    return interaction.reply({ embeds: [em("❌ Not whitelisted", t(interaction.locale, "not_whitelisted"), C.err)], flags: MessageFlags.Ephemeral });
                }
                const [key, e] = entry;
                const cooldown = e.hwid_cooldown || 0;
                if (Date.now() < cooldown) {
                    return interaction.reply({
                        embeds: [em("⏳ Cooldown", `You can reset HWID again <t:${Math.floor(cooldown / 1000)}:R>`, C.warn)],
                        flags: MessageFlags.Ephemeral
                    });
                }
                db[key].hwid          = null;
                db[key].hwid_cooldown = Date.now() + 3 * 86400000;
                await saveDB(db);
                await interaction.reply({ embeds: [em("✅ HWID Reset", "Your HWID has been reset. Next reset available in **3 days**.", C.ok)], flags: MessageFlags.Ephemeral });
                if (guild) await logTo(guild, "ch_key_logs", em("🔄 HWID Self-Reset", `**User:** ${user} (${user.id})\n**Key:** \`${key}\``, C.warn));
                return;
            }

            // ---- panel_getstats ----
            if (customId === "panel_getstats") {
                const db    = await loadDB();
                const entry = Object.entries(db).find(([, e]) => e.discordId === user.id);
                if (!entry) {
                    return interaction.reply({ embeds: [em("❌ Not whitelisted", t(interaction.locale, "not_whitelisted"), C.err)], flags: MessageFlags.Ephemeral });
                }
                const [key, e] = entry;
                const status = e.banned ? "🔨 Blacklisted" : e.expires && Date.now() > e.expires ? "⏰ Expired" : e.hwid ? "✅ Active" : "⏳ Waiting for first use";
                const cd     = e.hwid_cooldown && Date.now() < e.hwid_cooldown
                    ? `<t:${Math.floor(e.hwid_cooldown / 1000)}:R>` : "✅ Ready";
                return interaction.reply({
                    embeds: [em(
                        "📊 Your Stats",
                        `**Status:** ${status}\n**Key:** ||${key}||\n**Expires:** ${keyExpStr(e.expires)}\n**HWID:** \`${e.hwid || "Not bound yet"}\`\n**HWID reset:** ${cd}\n**Note:** ${e.note || "—"}${e.banReason ? "\n**Ban reason:** " + e.banReason : ""}`,
                        C.key
                    )],
                    flags: MessageFlags.Ephemeral
                });
            }

            // ---- create_ticket ----
            if (customId === "create_ticket") {
                const cfg = await getCFG(guild.id);
                const category = guild.channels.cache.get(cfg.ticket_category);
                if (!category) return interaction.reply({ embeds: [em("❌ Error", "Ticket category not set up.", C.err)], flags: MessageFlags.Ephemeral });

                const existing = guild.channels.cache.find(ch =>
                    ch.parentId === category.id && ch.topic === `ticket:${user.id}`
                );
                if (existing) return interaction.reply({ embeds: [em("⚠️ Already exists", `You already have a ticket: ${existing}`, C.warn)], flags: MessageFlags.Ephemeral });

                const ticket = await guild.channels.create({
                    name: `ticket-${user.username}`,
                    type: 0,
                    parent: category.id,
                    topic: `ticket:${user.id}`,
                    permissionOverwrites: [
                        { id: guild.id, deny: [PermissionsBitField.Flags.ViewChannel] },
                        { id: user.id, allow: [PermissionsBitField.Flags.ViewChannel, PermissionsBitField.Flags.SendMessages] },
                        { id: bot.user.id, allow: [PermissionsBitField.Flags.ViewChannel, PermissionsBitField.Flags.SendMessages] },
                    ]
                });

                if (cfg.support_role) {
                    await ticket.permissionOverwrites.edit(cfg.support_role, {
                        ViewChannel: true, SendMessages: true
                    });
                }

                const closeBtn = new ButtonBuilder()
                    .setCustomId("close_ticket")
                    .setLabel("🔒 Close")
                    .setStyle(ButtonStyle.Danger);

                await ticket.send({
                    content: `${user}${cfg.support_role ? " | <@&" + cfg.support_role + ">" : ""}`,
                    embeds: [em("🎫 Ticket Created", "Describe your issue. Support will respond shortly.", C.key)],
                    components: [new ActionRowBuilder().addComponents(closeBtn)]
                });

                return interaction.reply({ embeds: [em("✅ Created", `Ticket: ${ticket}`, C.ok)], flags: MessageFlags.Ephemeral });
            }

            // ---- close_ticket ----
            if (customId === "close_ticket") {
                const channel = interaction.channel;
                if (!channel.topic || !channel.topic.startsWith("ticket:")) {
                    return interaction.reply({ embeds: [em("❌ Error", "Not a ticket channel.", C.err)], flags: MessageFlags.Ephemeral });
                }
                await interaction.reply({ embeds: [em("🔒 Closing", "Ticket will be deleted in 5 seconds...", C.warn)] });
                setTimeout(() => channel.delete().catch(() => {}), 5000);
                return;
            }

            return;
        }

        // ----------------------------------------------------------------
        // MODALS
        // ----------------------------------------------------------------
        if (interaction.isModalSubmit()) {
            const { customId, user } = interaction;

            // ---- verify_modal ----
            if (customId === "verify_modal") {
                const inputCode = interaction.fields.getTextInputValue("code_input").trim();
                const pending   = await getKey("verif_" + user.id);

                if (!pending) {
                    return interaction.reply({ content: t(interaction.locale, "no_active_code"), flags: MessageFlags.Ephemeral });
                }

                // Лимит попыток (3)
                const newAttempts = (pending.attempts || 0) + 1;
                if (newAttempts > 3) {
                    await deleteKey("verif_" + user.id);
                    return interaction.reply({ content: t(pending.locale || interaction.locale, "too_many_attempts"), flags: MessageFlags.Ephemeral });
                }

                if (Date.now() > pending.expires) {
                    await deleteKey("verif_" + user.id);
                    return interaction.reply({ content: t(pending.locale || interaction.locale, "code_expired"), flags: MessageFlags.Ephemeral });
                }
                if (inputCode !== pending.code) {
                    await setKey("verif_" + user.id, { ...pending, attempts: newAttempts });
                    return interaction.reply({ content: t(pending.locale || interaction.locale, "wrong_code"), flags: MessageFlags.Ephemeral });
                }

                // Код верный
                await deleteKey("verif_" + user.id);
                const loc = pending.locale || interaction.locale;

                try {
                    const targetGuild = await bot.guilds.fetch(pending.guildId);
                    const member      = await targetGuild.members.fetch(user.id);
                    const role        = targetGuild.roles.cache.get(pending.roleId);

                    if (!role) throw new Error("Role " + pending.roleId + " not found");

                    const botMember = targetGuild.members.cache.get(bot.user.id)
                        || await targetGuild.members.fetch(bot.user.id);

                    if (role.position >= botMember.roles.highest.position) {
                        throw new Error("Role is higher than bot's highest role");
                    }

                    await member.roles.add(role);

                    // Снимаем unverified роль
                    const vCfg = await getCFG(targetGuild.id);
                    if (vCfg.unverified_role) {
                        try { await member.roles.remove(vCfg.unverified_role); } catch (e) {}
                    }

                    const title = t(loc, "verified");
                    const msg   = t(loc, "welcome", targetGuild.name);

                    await interaction.reply({ embeds: [em(title, msg, C.ok)] });
                    await logTo(targetGuild, "ch_join_logs", em("✅ Verified", `**User:** ${user} (${user.id})`, C.add));
                } catch (e) {
                    console.error("Role assign error:", e.message);
                    await interaction.reply({
                        content: t(loc, "role_error", e.message),
                        flags: MessageFlags.Ephemeral
                    });
                }
                return;
            }

            // ---- redeem_modal ----
            if (customId === "redeem_modal") {
                const inputKey = interaction.fields.getTextInputValue("redeem_input").trim();
                const data = await getKey(inputKey);
                if (!data) return interaction.reply({ embeds: [em("❌ Invalid", "Key not found.", C.err)], flags: MessageFlags.Ephemeral });
                if (data.banned) return interaction.reply({ embeds: [em("🔨 Banned", data.banReason || "Banned.", C.err)], flags: MessageFlags.Ephemeral });
                if (data.expires && Date.now() > data.expires) return interaction.reply({ embeds: [em("⏰ Expired", "Key expired.", C.err)], flags: MessageFlags.Ephemeral });
                if (data.discordId && data.discordId !== user.id) return interaction.reply({ embeds: [em("❌ Error", "This key is assigned to another user.", C.err)], flags: MessageFlags.Ephemeral });

                const db = await loadDB();
                db[inputKey].discordId = user.id;
                db[inputKey].discordTag = user.username;
                await saveDB(db);

                // Выдаём buyer role если возможно
                if (interaction.guild) {
                    const cfg = await getCFG(interaction.guild.id);
                    if (cfg.buyer_role) {
                        const buyerRole = interaction.guild.roles.cache.get(cfg.buyer_role);
                        if (buyerRole) {
                            try {
                                const botMember = interaction.guild.members.cache.get(bot.user.id) || await interaction.guild.members.fetch(bot.user.id);
                                if (buyerRole.position < botMember.roles.highest.position && botMember.permissions.has(PermissionsBitField.Flags.ManageRoles)) {
                                    await interaction.member.roles.add(buyerRole);
                                }
                            } catch (e) {
                                console.error("redeem role error:", e.message);
                            }
                        }
                    }
                }

                return interaction.reply({ embeds: [em("✅ Key Redeemed", `Key \`${inputKey}\` linked to your account!`, C.ok)], flags: MessageFlags.Ephemeral });
            }

            return;
        }

        // ----------------------------------------------------------------
        // SLASH COMMANDS
        // ----------------------------------------------------------------
        if (!interaction.isChatInputCommand()) return;

        const { commandName, guild, user } = interaction;

        // ================================================================
        // /setup
        // ================================================================
        if (commandName === "setup") {
            await interaction.deferReply({ flags: MessageFlags.Ephemeral });

            const cat = await guild.channels.create({
                name: "📋 logs",
                type: 4,
                permissionOverwrites: [
                    { id: guild.id,      deny:  [PermissionsBitField.Flags.ViewChannel] },
                    { id: bot.user.id,   allow: [PermissionsBitField.Flags.ViewChannel, PermissionsBitField.Flags.SendMessages] }
                ]
            });

            const channelDefs = [
                { key: "ch_message_logs", name: "message-logs"          },
                { key: "ch_command_logs", name: "command-logs"           },
                { key: "ch_join_logs",    name: "join-logs"              },
                { key: "ch_role_logs",    name: "role-logs"              },
                { key: "ch_auth_logs",    name: "script-auth-logs"       },
                { key: "ch_exec_logs",    name: "script-execution-logs"  },
                { key: "ch_crack_logs",   name: "crack-logs"             },
                { key: "ch_key_logs",     name: "key-logs"               },
            ];

            const created = {};
            for (const d of channelDefs) {
                const ch = await guild.channels.create({
                    name: d.name,
                    type: 0,
                    parent: cat.id,
                    permissionOverwrites: [
                        { id: guild.id,    deny:  [PermissionsBitField.Flags.ViewChannel] },
                        { id: bot.user.id, allow: [PermissionsBitField.Flags.ViewChannel, PermissionsBitField.Flags.SendMessages] }
                    ]
                });
                created[d.key] = ch.id;
            }

            await setCFG(guild.id, { ...created, category_id: cat.id });

            const lines = channelDefs.map(d => `✅ <#${created[d.key]}>`).join("\n");
            await interaction.editReply({ embeds: [em("✅ Setup Complete", lines + "\n\nИспользуй **/setverify** для настройки верификации.", C.ok)] });
            await logTo(guild, "ch_command_logs", em("⚙️ Setup", `Bot setup by ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /setverify
        // ================================================================
        if (commandName === "setverify") {
            await interaction.deferReply({ flags: MessageFlags.Ephemeral });
            const channel = interaction.options.getChannel("channel");
            const role    = interaction.options.getRole("role");

            await setCFG(guild.id, { verify_role: role.id, verify_channel: channel.id });

            const btn = new ButtonBuilder()
                .setCustomId("verify_btn")
                .setLabel("✅  Verify me")
                .setStyle(ButtonStyle.Success);

            const embed = new EmbedBuilder()
                .setTitle("🔐 Verification")
                .setDescription("Click **Verify me** to get access.")
                .setColor(0xB0B0D1)
                .setFooter({ text: "Do not share your code" });

            await channel.send({ embeds: [embed], components: [new ActionRowBuilder().addComponents(btn)] });
            await interaction.editReply({ embeds: [em("✅ Done", `Verification message sent to ${channel}.\nRole to give: ${role}`, C.ok)] });
            return;
        }

        // ================================================================
        // /genkey
        // ================================================================
        if (commandName === "genkey") {
            const duration = interaction.options.getString("duration");
            const days     = interaction.options.getInteger("days");
            const target   = interaction.options.getUser("user");

            if (duration === "custom" && (!days || days < 1)) {
                return interaction.reply({ embeds: [em("❌ Error", "Select \"Custom days\" and enter the number of days.", C.err)], flags: MessageFlags.Ephemeral });
            }

            const expires = duration === "custom" ? Date.now() + days * 86400000 : null;
            const key     = "frost-" + crypto.randomBytes(6).toString("hex").toUpperCase() + "-" + crypto.randomBytes(6).toString("hex").toUpperCase() + "-" + crypto.randomBytes(4).toString("hex").toUpperCase();

            await setKey(key, {
                hwid: null, created: Date.now(), expires, banned: false,
                firstUsed: null, createdBy: user.id,
                discordId: target?.id || null
            });

            const exp  = keyExpStr(expires);
            const desc = `**Key:** \`${key}\`\n**Expires:** ${exp}${target ? "\n**For:** " + target : ""}`;
            await interaction.reply({
                embeds: [em("🔑 Key Generated", desc, C.ok)],
                flags: MessageFlags.Ephemeral
            });
            if (target) {
                try { await target.send({ embeds: [em("🔑 Your Key", `\`${key}\`\n**Expires:** ${exp}`, C.key)] }); } catch (e) {}
            }
            await logTo(guild, "ch_key_logs", em("🔑 Generated", `\`${key}\`\n**Expires:** ${exp}\n**By:** ${user}${target ? "\n**For:** " + target : ""}`, C.ok));
            return;
        }

        // ================================================================
        // /keyinfo
        // ================================================================
        if (commandName === "keyinfo") {
            const key  = interaction.options.getString("key");
            const data = await getKey(key);
            if (!data) return interaction.reply({ embeds: [em("❌ Not Found", "Key doesn't exist.", C.err)], flags: MessageFlags.Ephemeral });
            const status = data.banned ? "🔨 Banned" : Date.now() > (data.expires || Infinity) ? "⏰ Expired" : data.hwid ? "✅ Active" : "⏳ Unused";
            return interaction.reply({
                embeds: [em("🔑 Key Info",
                    `**Key:** \`${key}\`\n**Status:** ${status}\n**HWID:** \`${data.hwid || "Not bound"}\`\n**Expires:** ${keyExpStr(data.expires)}\n**Created:** <t:${Math.floor(data.created / 1000)}:R>${data.banReason ? "\n**Ban reason:** " + data.banReason : ""}`
                )],
                flags: MessageFlags.Ephemeral
            });
        }

        // ================================================================
        // /bankey
        // ================================================================
        if (commandName === "bankey") {
            const key    = interaction.options.getString("key");
            const reason = interaction.options.getString("reason") || "No reason";
            const data   = await getKey(key);
            if (!data) return interaction.reply({ embeds: [em("❌ Not Found", "", C.err)], flags: MessageFlags.Ephemeral });
            await setKey(key, { ...data, banned: true, banReason: reason });
            await interaction.reply({ embeds: [em("🔨 Banned", `\`${key}\`\n**Reason:** ${reason}`, C.err)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🔨 Key Banned", `\`${key}\`\n**Reason:** ${reason}\n**By:** ${user}`, C.err));
            return;
        }

        // ================================================================
        // /unbankey
        // ================================================================
        if (commandName === "unbankey") {
            const key  = interaction.options.getString("key");
            const data = await getKey(key);
            if (!data) return interaction.reply({ embeds: [em("❌ Not Found", "", C.err)], flags: MessageFlags.Ephemeral });
            const updated = { ...data, banned: false };
            delete updated.banReason;
            await setKey(key, updated);
            await interaction.reply({ embeds: [em("✅ Unbanned", `\`${key}\``, C.ok)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("✅ Unbanned", `\`${key}\`\n**By:** ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /resethwid
        // ================================================================
        if (commandName === "resethwid") {
            const key  = interaction.options.getString("key");
            const data = await getKey(key);
            if (!data) return interaction.reply({ embeds: [em("❌ Not Found", "", C.err)], flags: MessageFlags.Ephemeral });
            const old = data.hwid;
            await setKey(key, { ...data, hwid: null });
            await interaction.reply({ embeds: [em("🔄 HWID Reset", `\`${key}\`\nOld: \`${old || "none"}\``, C.warn)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🔄 HWID Reset", `\`${key}\`\n**By:** ${user}`, C.warn));
            return;
        }

        // ================================================================
        // /deletekey
        // ================================================================
        if (commandName === "deletekey") {
            const key  = interaction.options.getString("key");
            const data = await getKey(key);
            if (!data) return interaction.reply({ embeds: [em("❌ Not Found", "", C.err)], flags: MessageFlags.Ephemeral });
            await deleteKey(key);
            await interaction.reply({ embeds: [em("🗑️ Deleted", `\`${key}\``, C.err)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🗑️ Deleted", `\`${key}\`\n**By:** ${user}`, C.err));
            return;
        }

        // ================================================================
        // /extendkey
        // ================================================================
        if (commandName === "extendkey") {
            const key  = interaction.options.getString("key");
            const days = interaction.options.getInteger("days");
            const data = await getKey(key);
            if (!data) return interaction.reply({ embeds: [em("❌ Not Found", "", C.err)], flags: MessageFlags.Ephemeral });
            const base   = Math.max(data.expires || Date.now(), Date.now());
            const newExp  = base + days * 86400000;
            await setKey(key, { ...data, expires: newExp });
            await interaction.reply({ embeds: [em("⏰ Extended", `\`${key}\`\nNew: ${keyExpStr(newExp)}`, C.ok)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("⏰ Extended", `\`${key}\`\n+${days} days\n**By:** ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /listkeys
        // ================================================================
        if (commandName === "listkeys") {
            const filter = interaction.options.getString("filter") || "all";
            const db     = await loadDB();
            let keys     = Object.entries(db);

            if (filter === "active")  keys = keys.filter(([, e]) => !e.banned && e.hwid && (!e.expires || Date.now() < e.expires));
            if (filter === "banned")  keys = keys.filter(([, e]) => e.banned);
            if (filter === "expired") keys = keys.filter(([, e]) => e.expires && Date.now() > e.expires);
            if (filter === "unused")  keys = keys.filter(([, e]) => !e.hwid && !e.banned);

            if (!keys.length) return interaction.reply({ embeds: [em("📋 Keys", "No keys found.")], flags: MessageFlags.Ephemeral });

            const lines = keys.slice(0, 25).map(([k, e]) => {
                const s = e.banned ? "🔨" : e.expires && Date.now() > e.expires ? "⏰" : e.hwid ? "✅" : "⏳";
                return `${s} \`${k}\``;
            });
            if (keys.length > 25) lines.push(`...+${keys.length - 25} more`);

            return interaction.reply({ embeds: [em("📋 Keys (" + keys.length + ")", lines.join("\n"))], flags: MessageFlags.Ephemeral });
        }

        // ================================================================
        // /stats
        // ================================================================
        if (commandName === "stats") {
            const db  = await loadDB();
            const all = Object.values(db);
            return interaction.reply({
                embeds: [em("📊 Stats",
                    `**Total:** ${all.length}\n✅ Active: **${all.filter(e => !e.banned && e.hwid && (!e.expires || Date.now() < e.expires)).length}**\n⏳ Unused: **${all.filter(e => !e.hwid && !e.banned).length}**\n🔨 Banned: **${all.filter(e => e.banned).length}**\n⏰ Expired: **${all.filter(e => e.expires && Date.now() > e.expires && !e.banned).length}**`
                )],
                flags: MessageFlags.Ephemeral
            });
        }

        // ================================================================
        // /checkkey
        // ================================================================
        if (commandName === "checkkey") {
            const key  = interaction.options.getString("key");
            const data = await getKey(key);
            if (!data)                                              return interaction.reply({ embeds: [em("❌ Invalid", "Key not found.", C.err)], flags: MessageFlags.Ephemeral });
            if (data.banned)                                        return interaction.reply({ embeds: [em("🔨 Banned", data.banReason || "Banned.", C.err)], flags: MessageFlags.Ephemeral });
            if (data.expires && Date.now() > data.expires)         return interaction.reply({ embeds: [em("⏰ Expired", "Key expired.", C.err)], flags: MessageFlags.Ephemeral });
            return interaction.reply({ embeds: [em("✅ Valid", `**Expires:** ${keyExpStr(data.expires)}\n**HWID bound:** ${data.hwid ? "Yes" : "No"}`, C.ok)], flags: MessageFlags.Ephemeral });
        }

        // ================================================================
        // /whitelist
        // ================================================================
        if (commandName === "whitelist") {
            const target  = interaction.options.getUser("user");
            const days    = interaction.options.getInteger("days");
            const note    = interaction.options.getString("note") || "";
            const db      = await loadDB();
            const existing = Object.entries(db).find(([, e]) => e.discordId === target.id);

            if (existing) {
                const [eKey, eData] = existing;
                if (days) {
                    const base   = Math.max(eData.expires || Date.now(), Date.now());
                    const newExp = base + days * 86400000;
                    await setKey(eKey, { ...eData, expires: newExp });
                    return interaction.reply({ embeds: [em("⏰ Time Added", `Added **${days}** days to ${target}\nNew expiry: ${keyExpStr(newExp)}`, C.ok)], flags: MessageFlags.Ephemeral });
                }
                return interaction.reply({ embeds: [em("ℹ️ Already whitelisted", `${target} already has key \`${eKey}\`\nUse \`/extendkey\` to add time.`, C.warn)], flags: MessageFlags.Ephemeral });
            }

            const key     = "frost-" + crypto.randomBytes(6).toString("hex").toUpperCase() + "-" + crypto.randomBytes(6).toString("hex").toUpperCase() + "-" + crypto.randomBytes(4).toString("hex").toUpperCase();
            const expires = days ? Date.now() + days * 86400000 : null;

            await setKey(key, {
                hwid: null, created: Date.now(), expires, banned: false, firstUsed: null,
                createdBy: user.id, discordId: target.id, discordTag: target.username,
                note, hwid_cooldown: 0
            });

            try {
                await target.send({ embeds: [em("🔑 You have been whitelisted!", `**frost.vip** — your license key:\n\`${key}\`\n**Expires:** ${keyExpStr(expires)}\n\nPaste this in your script:\n\`\`\`lua\nlocal script_key = "${key}"\n\`\`\``, C.key)] });
            } catch (e) {}

            await interaction.reply({ embeds: [em("✅ Whitelisted", `${target} has been whitelisted!\n**Key:** \`${key}\`\n**Expires:** ${keyExpStr(expires)}`, C.ok)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("✅ Whitelisted", `**User:** ${target} (${target.id})\n**Key:** \`${key}\`\n**Expires:** ${keyExpStr(expires)}\n**By:** ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /blacklist
        // ================================================================
        if (commandName === "blacklist") {
            const userId = interaction.options.getString("userid");
            const reason = interaction.options.getString("reason") || "No reason";
            const days   = interaction.options.getInteger("days");

            if (!/^\d+$/.test(userId)) {
                return interaction.reply({ embeds: [em("❌ Invalid ID", "User ID must be a number.", C.err)], flags: MessageFlags.Ephemeral });
            }

            const db     = await loadDB();
            const entry  = Object.entries(db).find(([, e]) => e.discordId === userId);

            if (!entry) return interaction.reply({ embeds: [em("❌ Not Found", "User has no key in database.", C.err)], flags: MessageFlags.Ephemeral });

            const [key, data] = entry;
            const until = days ? Date.now() + days * 86400000 : null;
            await setKey(key, { ...data, banned: true, banReason: reason, blacklistedUntil: until });

            const untilStr = until ? `<t:${Math.floor(until / 1000)}:F>` : "Permanent";
            await interaction.reply({ embeds: [em("🔨 Blacklisted", `<@${userId}>\n**Reason:** ${reason}\n**Until:** ${untilStr}`, C.err)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🔨 Blacklisted", `**User:** <@${userId}>\n**Reason:** ${reason}\n**Until:** ${untilStr}\n**By:** ${user}`, C.err));
            return;
        }

        // ================================================================
        // /unblacklist
        // ================================================================
        if (commandName === "unblacklist") {
            const userId = interaction.options.getString("userid");
            const db     = await loadDB();
            const entry  = Object.entries(db).find(([, e]) => e.discordId === userId);
            if (!entry) return interaction.reply({ embeds: [em("❌ Not Found", "User not in database.", C.err)], flags: MessageFlags.Ephemeral });

            const [key, data] = entry;
            const updated = { ...data, banned: false };
            delete updated.banReason;
            delete updated.blacklistedUntil;
            await setKey(key, updated);

            await interaction.reply({ embeds: [em("✅ Unblacklisted", `<@${userId}> has been unblacklisted.`, C.ok)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("✅ Unblacklisted", `**User:** <@${userId}>\n**By:** ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /getstats
        // ================================================================
        if (commandName === "getstats") {
            const userId = interaction.options.getString("userid");
            const db     = await loadDB();
            const entry  = Object.entries(db).find(([, e]) => e.discordId === userId);
            if (!entry) return interaction.reply({ embeds: [em("❌ Not Found", "User has no key.", C.err)], flags: MessageFlags.Ephemeral });

            const [key, e] = entry;
            const status = e.banned ? "🔨 Blacklisted" : Date.now() > (e.expires || Infinity) ? "⏰ Expired" : e.hwid ? "✅ Active" : "⏳ Unused";
            const hwidCd = e.hwid_cooldown && Date.now() < e.hwid_cooldown
                ? `<t:${Math.floor(e.hwid_cooldown / 1000)}:R>` : "Ready";

            return interaction.reply({
                embeds: [em("📊 User Stats",
                    `**User:** <@${userId}>\n**Key:** ||${key}||\n**Status:** ${status}\n**Expires:** ${keyExpStr(e.expires)}\n**HWID:** \`${e.hwid || "Not bound"}\`\n**HWID reset:** ${hwidCd}\n**Note:** ${e.note || "—"}${e.banReason ? "\n**Ban reason:** " + e.banReason : ""}`
                )],
                flags: MessageFlags.Ephemeral
            });
        }

        // ================================================================
        // /setnote
        // ================================================================
        if (commandName === "setnote") {
            const userId = interaction.options.getString("userid");
            const note   = interaction.options.getString("note");
            const db     = await loadDB();
            const entry  = Object.entries(db).find(([, e]) => e.discordId === userId);
            if (!entry) return interaction.reply({ embeds: [em("❌ Not Found", "User not in database.", C.err)], flags: MessageFlags.Ephemeral });
            await setKey(entry[0], { ...entry[1], note });
            await interaction.reply({ embeds: [em("📝 Note Set", `<@${userId}>\n${note}`, C.warn)], flags: MessageFlags.Ephemeral });
            return;
        }

        // ================================================================
        // /erase
        // ================================================================
        if (commandName === "erase") {
            const userId = interaction.options.getString("userid");
            const db     = await loadDB();
            const entry  = Object.entries(db).find(([, e]) => e.discordId === userId);
            if (!entry) return interaction.reply({ embeds: [em("❌ Not Found", "User not in database.", C.err)], flags: MessageFlags.Ephemeral });
            await deleteKey(entry[0]);
            await interaction.reply({ embeds: [em("🗑️ Erased", `<@${userId}> fully removed.`, C.err)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🗑️ User Erased", `**User:** <@${userId}>\n**By:** ${user}`, C.err));
            return;
        }

        // ================================================================
        // /compensate
        // ================================================================
        if (commandName === "compensate") {
            const days = interaction.options.getInteger("days");
            const db   = await loadDB();
            let count  = 0;

            for (const key in db) {
                if (!db[key].banned && (!db[key].expires || Date.now() < db[key].expires)) {
                    const base = Math.max(db[key].expires || Date.now(), Date.now());
                    db[key].expires = base + days * 86400000;
                    count++;
                }
            }

            await saveDB(db);
            await interaction.reply({ embeds: [em("🎁 Compensated", `Added **${days}** days to **${count}** active users.`, C.ok)], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🎁 Compensation", `+${days} days for ${count} users\n**By:** ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /generatekeys
        // ================================================================
        if (commandName === "generatekeys") {
            const count    = interaction.options.getInteger("count");
            const duration = interaction.options.getString("duration");
            const days     = interaction.options.getInteger("days");

            if (duration === "custom" && (!days || days < 1)) {
                return interaction.reply({ embeds: [em("❌ Error", "Select \"Custom days\" and enter the number of days.", C.err)], flags: MessageFlags.Ephemeral });
            }

            const expires = duration === "custom" ? Date.now() + days * 86400000 : null;
            const lines   = [];

            for (let i = 0; i < count; i++) {
                const key = "frost-" + crypto.randomBytes(6).toString("hex").toUpperCase() + "-" + crypto.randomBytes(6).toString("hex").toUpperCase() + "-" + crypto.randomBytes(4).toString("hex").toUpperCase();
                await setKey(key, { hwid: null, created: Date.now(), expires, banned: false, firstUsed: null, createdBy: user.id, redeemable: true });
                lines.push(key);
            }

            const buf  = Buffer.from(lines.join("\n"), "utf8");
            const file = new AttachmentBuilder(buf, { name: "keys.txt" });

            await interaction.reply({ content: `Generated **${count}** keys${duration === "custom" ? " (" + days + " days)" : " (lifetime)"}.`, files: [file], flags: MessageFlags.Ephemeral });
            await logTo(guild, "ch_key_logs", em("🔑 Keys Generated", `**Count:** ${count}\n**Duration:** ${duration === "custom" ? days + " days" : "lifetime"}\n**By:** ${user}`, C.ok));
            return;
        }

        // ================================================================
        // /panel
        // ================================================================
        if (commandName === "panel") {
            const row = new ActionRowBuilder().addComponents(
                new ButtonBuilder().setCustomId("panel_redeemkey").setLabel("Redeem Key").setEmoji("🔑").setStyle(ButtonStyle.Success),
                new ButtonBuilder().setCustomId("panel_getscript").setLabel("Get Script").setEmoji("📜").setStyle(ButtonStyle.Primary),
                new ButtonBuilder().setCustomId("panel_getrole").setLabel("Get Role").setEmoji("👤").setStyle(ButtonStyle.Primary),
                new ButtonBuilder().setCustomId("panel_resethwid").setLabel("Reset HWID").setEmoji("⚙️").setStyle(ButtonStyle.Secondary),
                new ButtonBuilder().setCustomId("panel_getstats").setLabel("Get Stats").setEmoji("📊").setStyle(ButtonStyle.Secondary)
            );
            const embed = em(
                "frost.vip",
                "If you're a buyer, click on the buttons below to redeem your key, get the script or get your role.",
                C.key
            ).setFooter({ text: `Sent by ${user.username}` });
            await interaction.channel.send({ embeds: [embed], components: [row] });
            await interaction.reply({ content: "Panel sent!", flags: MessageFlags.Ephemeral });
            return;
        }

        // ================================================================
        // /setunverified
        // ================================================================
        if (commandName === "setunverified") {
            const role = interaction.options.getRole("role");
            await setCFG(guild.id, { unverified_role: role.id });
            await interaction.reply({
                embeds: [em("✅ Done",
                    `Role ${role} will now be given to every new member on join.\n\nMake sure this role has **no access to channels** except the verify channel.`,
                    C.ok)],
                flags: MessageFlags.Ephemeral
            });
            return;
        }

        // ================================================================
        // /setbuyer
        // ================================================================
        if (commandName === "setbuyer") {
            const role = interaction.options.getRole("role");
            await setCFG(guild.id, { buyer_role: role.id });
            await interaction.reply({
                embeds: [em("✅ Done", `Buyer role set to ${role}.\nUsers who redeem a key or click "Get Role" in the panel will receive this role.`, C.ok)],
                flags: MessageFlags.Ephemeral
            });
            return;
        }

        // ================================================================
        // /setsupport
        // ================================================================
        if (commandName === "setsupport") {
            const role = interaction.options.getRole("role");
            await setCFG(guild.id, { support_role: role.id });
            await interaction.reply({
                embeds: [em("✅ Done", `Support role set to ${role}.\nThey will be able to see all ticket channels.`, C.ok)],
                flags: MessageFlags.Ephemeral
            });
            return;
        }

        // ================================================================
        // /settickets
        // ================================================================
        if (commandName === "settickets") {
            const channel  = interaction.options.getChannel("channel");
            const category = interaction.options.getChannel("category");

            if (category.type !== 4) {
                return interaction.reply({ embeds: [em("❌ Error", "Second argument must be a **category** channel.", C.err)], flags: MessageFlags.Ephemeral });
            }

            await setCFG(guild.id, { ticket_channel: channel.id, ticket_category: category.id });

            const btn = new ButtonBuilder()
                .setCustomId("create_ticket")
                .setLabel("🎫 Create Ticket")
                .setStyle(ButtonStyle.Primary);

            await channel.send({
                embeds: [em("🎫 Support", "Click the button below to create a ticket.", C.key)],
                components: [new ActionRowBuilder().addComponents(btn)]
            });
            await interaction.reply({ embeds: [em("✅ Done", `Ticket panel sent to ${channel}.\nTicket category: ${category}`, C.ok)], flags: MessageFlags.Ephemeral });
            return;
        }

    } catch (e) {
        console.error("interactionCreate error:", e);
        try {
            const errEmbed = em("❌ Error", "An internal error occurred. Please try again.", C.err);
            if (interaction.deferred || interaction.replied) {
                await interaction.editReply({ embeds: [errEmbed] });
            } else {
                await interaction.reply({ embeds: [errEmbed], flags: MessageFlags.Ephemeral });
            }
        } catch (e2) {}
    }
});


// ============================================================
// logAuth — вызывается из server.js
// ============================================================
async function logAuth(guildId, info, status) {
    const guild = bot.guilds.cache.get(guildId);
    if (!guild) return;

    const { key, hwid, user, discord_id, discord_tag, gameName } = info;
    const isOk = status === "ok" || status === "activated";
    const statusMap = {
        ok:             "✅ Valid",
        activated:      "🆕 First activation",
        invalid:        "❌ Invalid",
        banned:         "🔨 Banned",
        expired:        "⏰ Expired",
        hwid_mismatch:  "🚨 HWID mismatch"
    };

    await logTo(guild, "ch_auth_logs", em(
        isOk ? "✅ Authenticated" : "❌ Auth Failed",
        `**Key:** \`${key}\`\n**Status:** ${statusMap[status] || status}\n**Roblox:** \`${user || "?"}\`\n**Discord ID:** \`${discord_id || "—"}\`\n**Discord tag:** \`${discord_tag || "—"}\`\n**Game:** ${gameName || "?"}\n**HWID:** \`${hwid}\``,
        isOk ? C.ok : C.err
    ));

    if (status === "activated") {
        await logTo(guild, "ch_key_logs", em(
            "🆕 First Activation",
            `**Key:** \`${key}\`\n**By:** \`${user}\` | \`${discord_tag || discord_id || "?"}\`\n**Game:** ${gameName || "?"}`,
            C.ok
        ));
    }

    if (status === "hwid_mismatch") {
        await logTo(guild, "ch_crack_logs", em(
            "🚨 Crack Attempt",
            `**Key:** \`${key}\`\n**HWID:** \`${hwid}\`\n**Roblox:** \`${user}\`\n**Discord:** \`${discord_tag || discord_id || "?"}\``,
            0xFF0000
        ));
    }
}

module.exports = { logAuth };

bot.login(process.env.DISCORD_TOKEN);
