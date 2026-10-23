import 'package:flutter/material.dart';
import '../../models/community_post.dart';
import '../../core/constants/app_colors.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: 'cp1',
      authorName: 'जगदीश सिंह',
      authorLocation: 'पटियाला, पंजाब',
      title: 'गेहूँ की बुवाई में सुपर सीडर तकनीक का अनुभव',
      content: 'किसान भाइयों, इस बार मैंने पराली जलाए बिना सीधे सुपर सीडर से गेहूँ की बिजाई की। जमाव 95% से अधिक रहा है और खाद की बचत भी हुई है। किसी भाई को कोई सवाल हो तो जरूर पूछें।',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      likes: 24,
      comments: ['बहुत बढ़िया पहल जगदीश जी!', 'बीज की गहराई कितनी रखी आपने?'],
    ),
    CommunityPost(
      id: 'cp2',
      authorName: 'विकास पाटीदार',
      authorLocation: 'उज्जैन, मध्य प्रदेश',
      title: 'चने में उकठा (Wilt) रोग से बचाव के घरेलू व जैविक उपाय',
      content: 'चने की बुवाई से पहले बीजोपचार ट्राइकोडर्मा विरिडी (Trichoderma viride) 10 ग्राम प्रति कि.ग्रा. से किया था। अब तक खेत में उकठा का प्रकोप बिल्कुल शून्य है। जैविक खेती अपनाएं।',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 42,
      comments: ['ट्राइकोडर्मा किस कंपनी का लिया था?'],
    ),
  ];

  void _showNewPostDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('चौपाल पर चर्चा शुरू करें'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'विषय / सवाल')),
            const SizedBox(height: 8),
            TextField(controller: contentCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'अपना अनुभव या सवाल विस्तार से लिखें...')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty && contentCtrl.text.isNotEmpty) {
                setState(() {
                  _posts.insert(
                    0,
                    CommunityPost(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      authorName: 'रामेश्वर पटेल (किसान)',
                      authorLocation: 'इंदौर, मध्य प्रदेश',
                      title: titleCtrl.text,
                      content: contentCtrl.text,
                      timestamp: DateTime.now(),
                      likes: 1,
                      comments: [],
                    ),
                  );
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('पोस्ट करें'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _showNewPostDialog,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text('सवाल पूछें', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Text(post.authorName.isNotEmpty ? post.authorName[0] : 'K', style: const TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('📍 ${post.authorLocation}', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                Text(post.content, style: const TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined, size: 18, color: AppColors.primary),
                      onPressed: () {
                        setState(() => post.likes++);
                      },
                    ),
                    Text('${post.likes} पसंद', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    const Icon(Icons.comment_outlined, size: 18, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text('${post.comments.length} टिप्पणियां', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
