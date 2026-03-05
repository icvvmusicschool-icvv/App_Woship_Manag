import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_feed_widget.dart';
import './widgets/quick_action_card_widget.dart';
import './widgets/upcoming_schedule_card_widget.dart';
import './widgets/welcome_header_widget.dart';

class DashboardHomeScreenInitialPage extends StatefulWidget {
  const DashboardHomeScreenInitialPage({super.key});

  @override
  State<DashboardHomeScreenInitialPage> createState() =>
      _DashboardHomeScreenInitialPageState();
}

class _DashboardHomeScreenInitialPageState
    extends State<DashboardHomeScreenInitialPage> {
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _upcomingSchedules = [
    {
      "id": 1,
      "title": "Culto Dominical",
      "date": "09/03/2026",
      "time": "09:00",
      "musicians": ["Carlos Silva", "Ana Souza", "Pedro Lima"],
      "status": "confirmado",
      "pendingCount": 0,
    },
    {
      "id": 2,
      "title": "Culto de Quarta",
      "date": "11/03/2026",
      "time": "19:30",
      "musicians": ["Maria Costa", "João Ferreira"],
      "status": "pendente",
      "pendingCount": 2,
    },
    {
      "id": 3,
      "title": "Culto de Louvor",
      "date": "15/03/2026",
      "time": "18:00",
      "musicians": ["Lucas Oliveira", "Beatriz Santos", "Rafael Mendes"],
      "status": "confirmado",
      "pendingCount": 0,
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "type": "musica",
      "description":
          "Nova cifra adicionada: 'Oceanos (Onde Meus Pés Podem Falhar)'",
      "timestamp": "04/03/2026 14:22",
      "icon": "library_music",
    },
    {
      "id": 2,
      "type": "musico",
      "description": "Carlos Silva confirmou disponibilidade para 09/03/2026",
      "timestamp": "04/03/2026 11:05",
      "icon": "person_add",
    },
    {
      "id": 3,
      "type": "escala",
      "description": "Escala do Culto Dominical atualizada",
      "timestamp": "03/03/2026 16:40",
      "icon": "calendar_today",
    },
    {
      "id": 4,
      "type": "evento",
      "description": "Novo evento: Retiro de Louvor - 22/03/2026",
      "timestamp": "03/03/2026 09:15",
      "icon": "event",
    },
    {
      "id": 5,
      "type": "musica",
      "description": "Cifra transposta: 'Grande é o Senhor' de C para D",
      "timestamp": "02/03/2026 20:30",
      "icon": "music_note",
    },
  ];

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 10.w,
                    height: 0.5.h,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Ação Rápida',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.5.h),
                _buildSheetAction(
                  ctx,
                  icon: 'calendar_today',
                  label: 'Nova Escala',
                  color: theme.colorScheme.primary,
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
                _buildSheetAction(
                  ctx,
                  icon: 'library_music',
                  label: 'Adicionar Música',
                  color: AppTheme.successColor,
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
                _buildSheetAction(
                  ctx,
                  icon: 'event',
                  label: 'Criar Evento',
                  color: AppTheme.warningColor,
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSheetAction(
    BuildContext context, {
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CustomIconWidget(iconName: icon, color: color, size: 22),
        ),
      ),
      title: Text(label, style: theme.textTheme.bodyLarge),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: theme.colorScheme.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: WelcomeHeaderWidget(
                    userName: 'Pastor André',
                    userRole: 'Administrador',
                    churchName: 'Igreja Comunidade da Graça',
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                SliverToBoxAdapter(child: _buildQuickActions(theme)),
                SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                SliverToBoxAdapter(
                  child: Text(
                    'Próximas Escalas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 1.h)),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final schedule = _upcomingSchedules[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: UpcomingScheduleCardWidget(
                        schedule: schedule,
                        onEdit: () {},
                        onDuplicate: () {},
                        onSendReminder: () {},
                      ),
                    );
                  }, childCount: _upcomingSchedules.length),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 1.h)),
                SliverToBoxAdapter(
                  child: Text(
                    'Atividade Recente',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 1.h)),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final activity = _recentActivities[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: ActivityFeedWidget(activity: activity),
                    );
                  }, childCount: _recentActivities.length),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 2.h)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showQuickActionSheet,
        icon: CustomIconWidget(iconName: 'add', color: Colors.white, size: 22),
        label: Text(
          'Ação Rápida',
          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    final actions = [
      {
        "label": "Nova Escala",
        "icon": "calendar_today",
        "color": theme.colorScheme.primary,
        "route": "/escalas-management-screen",
      },
      {
        "label": "Adicionar Música",
        "icon": "library_music",
        "color": AppTheme.successColor,
        "route": "/music-library-screen",
      },
      {
        "label": "Criar Evento",
        "icon": "event",
        "color": AppTheme.warningColor,
        "route": "/events-management-screen",
      },
    ];

    return Row(
      children: actions.map((action) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: QuickActionCardWidget(
              label: action["label"] as String,
              iconName: action["icon"] as String,
              color: action["color"] as Color,
              onTap: () {},
            ),
          ),
        );
      }).toList(),
    );
  }
}
