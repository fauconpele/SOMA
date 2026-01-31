import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/common/simple_page_scaffold.dart';
import '../utils/launch.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  static const _email = 'contact@soma-rdc.org';
  static const _phone = '+243 999 867 334';
  static const _address = 'Kinshasa, République Démocratique du Congo';

  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController(); // ✅ pas d’objet par défaut
  final _messageCtrl = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _fromCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Veuillez renseigner votre email.';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    if (!ok) return 'Email invalide.';
    return null;
  }

  String? _validateRequired(String? v, String message) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return message;
    return null;
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text)); // ignore le Future
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copié : $text'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _buildMailtoUrl({
    required String to,
    required String body,
    String? subject,
  }) {
    final qp = <String, String>{'body': body};
    final s = (subject ?? '').trim();
    if (s.isNotEmpty) qp['subject'] = s; // ✅ ajoute seulement si rempli
    return Uri(scheme: 'mailto', path: to, queryParameters: qp).toString();
  }

  Future<void> _sendEmail() async {
    if (_isSending) return;

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() => _isSending = true);

    final name = _nameCtrl.text.trim();
    final from = _fromCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final subject = _subjectCtrl.text.trim();
    final message = _messageCtrl.text.trim();

    final body = [
      'Bonjour SOMA,',
      '',
      message,
      '',
      '—',
      'Nom : $name',
      'Email : $from',
      if (phone.isNotEmpty) 'Téléphone : $phone',
      '',
      'Envoyé depuis la page Contact (SOMA).',
    ].join('\n');

    final url = _buildMailtoUrl(
      to: _email,
      subject: subject,
      body: body,
    );

    try {
      await launchSmart(context, url);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SimplePageScaffold(
      title: 'Contact',
      child: LayoutBuilder(
        builder: (context, c) {
          final isWide = c.maxWidth >= 980;

          final content = isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildLeft(theme)),
                    const SizedBox(width: 22),
                    Expanded(child: _buildRight(theme)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLeft(theme),
                    const SizedBox(height: 22),
                    _buildRight(theme),
                  ],
                );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroHeader(
                title: 'Contactez SOMA',
                subtitle:
                    'Une question, un besoin d’accompagnement ou une demande d’informations ? Écrivez-nous et nous vous répondrons rapidement.',
                accent: cs.primary,
              ),
              const SizedBox(height: 18),
              content,
              const SizedBox(height: 18),
              _MiniNote(
                icon: Icons.verified_user_outlined,
                text:
                    'Conseil : plus votre message est précis (classe, matière, commune, disponibilité), plus nous pouvons vous aider efficacement.',
                color: cs.primary,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLeft(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _InfoCard(
          title: 'Coordonnées',
          icon: Icons.contact_mail_outlined,
          child: Column(
            children: [
              _ContactRow(
                icon: Icons.email_outlined,
                title: 'Email',
                value: _email,
                onTap: () => launchSmart(context, 'mailto:$_email'),
                onCopy: () => _copyToClipboard(_email, 'Email'),
              ),
              const SizedBox(height: 10),
              _ContactRow(
                icon: Icons.phone_outlined,
                title: 'Téléphone',
                value: _phone,
                onTap: () => launchSmart(context, 'tel:${_phone.replaceAll(' ', '')}'),
                onCopy: () => _copyToClipboard(_phone, 'Téléphone'),
              ),
              const SizedBox(height: 10),
              _ContactRow(
                icon: Icons.location_on_outlined,
                title: 'Adresse',
                value: _address,
                onTap: null,
                onCopy: () => _copyToClipboard(_address, 'Adresse'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Actions rapides',
          icon: Icons.flash_on_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _PrimaryActionButton(
                label: 'Écrire un mail',
                icon: Icons.mail_outline,
                color: cs.primary,
                onPressed: _isSending ? null : () => launchSmart(context, 'mailto:$_email'),
              ),
              const SizedBox(height: 10),
              _PrimaryActionButton(
                label: 'Appeler maintenant',
                icon: Icons.call_outlined,
                color: cs.secondary, // ✅ bien visible
                onPressed: _isSending
                    ? null
                    : () => launchSmart(context, 'tel:${_phone.replaceAll(' ', '')}'),
              ),
              const SizedBox(height: 12),
              _OutlineActionButton(
                label: 'Copier le numéro',
                icon: Icons.copy_rounded,
                color: cs.primary,
                onPressed: _isSending ? null : () => _copyToClipboard(_phone, 'Téléphone'),
              ),
              const SizedBox(height: 14),
              _MiniNote(
                icon: Icons.lock_outline,
                text: 'Vos informations servent uniquement à traiter votre demande. Aucun spam.',
                color: cs.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRight(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.primary.withOpacity(0.14)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary.withOpacity(0.06),
            cs.secondary.withOpacity(0.06),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.edit_note, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Envoyer un message',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "Remplissez ce formulaire. Le bouton ouvrira votre application mail avec le message prêt à envoyer.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.78),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _Field(
                  label: 'Nom complet',
                  hint: 'Ex : Raphaël MWELA KALALA',
                  controller: _nameCtrl,
                  validator: (v) => _validateRequired(v, 'Veuillez renseigner votre nom.'),
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _Field(
                  label: 'Votre email',
                  hint: 'Ex : nom@gmail.com',
                  controller: _fromCtrl,
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.alternate_email,
                ),
                const SizedBox(height: 12),
                _Field(
                  label: 'Téléphone (optionnel)',
                  hint: 'Ex : +243 …',
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  label: 'Objet (optionnel)',
                  hint: 'Ex : Demande de précepteur — Mathématiques',
                  controller: _subjectCtrl,
                  prefixIcon: Icons.subject_outlined,
                ),
                const SizedBox(height: 12),
                _Field(
                  label: 'Message',
                  hint: 'Décrivez votre besoin (classe, matière, lieu, horaires…).',
                  controller: _messageCtrl,
                  validator: (v) => _validateRequired(v, 'Veuillez écrire votre message.'),
                  prefixIcon: Icons.message_outlined,
                  maxLines: 6,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _PrimaryActionButton(
                        label: _isSending ? 'Ouverture…' : 'Envoyer',
                        icon: Icons.send_rounded,
                        color: cs.primary,
                        onPressed: _isSending ? null : () => _sendEmail(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _OutlineActionButton(
                        label: 'Réinitialiser',
                        icon: Icons.refresh_rounded,
                        color: cs.primary,
                        onPressed: _isSending
                            ? null
                            : () {
                                _nameCtrl.clear();
                                _fromCtrl.clear();
                                _phoneCtrl.clear();
                                _subjectCtrl.clear();
                                _messageCtrl.clear();
                                setState(() {});
                              },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _MiniNote(
                  icon: Icons.info_outline,
                  text:
                      "Astuce : si vous laissez l’objet vide, aucun objet ne sera ajouté automatiquement dans le mail.",
                  color: cs.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accent;

  const _HeroHeader({
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.16)),
        color: accent.withOpacity(0.06),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: accent.withOpacity(0.18),
            ),
            child: Icon(Icons.support_agent, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.80),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.65)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: cs.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cs.surfaceVariant.withOpacity(0.30),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.50)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cs.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.82),
                    ),
                  ),
                ],
              ),
            ),
            if (onCopy != null) ...[
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Copier',
                onPressed: onCopy,
                icon: Icon(Icons.copy_rounded, color: cs.primary),
              ),
            ],
            if (onTap != null)
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: cs.primary.withOpacity(0.9)),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData prefixIcon;
  final int maxLines;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon),
            filled: true,
            fillColor: cs.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.75)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.75)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: cs.primary, width: 1.6),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _MiniNote extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _MiniNote({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.18)),
        color: color.withOpacity(0.07),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.4,
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.86),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Bouton rempli (toujours visible)
class _PrimaryActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return color.withOpacity(0.45);
            }
            return color;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return 0;
            return 0;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}

/// ✅ Bouton contour (visible sur fonds clairs)
class _OutlineActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _OutlineActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) return color.withOpacity(0.45);
            return color;
          }),
          side: MaterialStateProperty.resolveWith((states) {
            final c = states.contains(MaterialState.disabled) ? color.withOpacity(0.30) : color.withOpacity(0.85);
            return BorderSide(color: c, width: 1.4);
          }),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),
    );
  }
}
