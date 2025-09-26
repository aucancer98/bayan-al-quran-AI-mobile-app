import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/service_manager.dart';

/// Widget to display connectivity status and handle offline mode
class ConnectivityStatus extends StatefulWidget {
  final Widget child;
  
  const ConnectivityStatus({
    super.key,
    required this.child,
  });
  
  @override
  State<ConnectivityStatus> createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus> {
  final ServiceManager _serviceManager = ServiceManager();
  bool _isOnline = true;
  
  @override
  void initState() {
    super.initState();
    _isOnline = _serviceManager.isOnline;
    _listenToConnectivity();
  }
  
  void _listenToConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isOnline = results.any((result) => result != ConnectivityResult.none);
      if (mounted && _isOnline != isOnline) {
        setState(() {
          _isOnline = isOnline;
        });
        _serviceManager.refreshConnectivity();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isOnline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.orange,
              child: Row(
                children: [
                  const Icon(
                    Icons.wifi_off,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'You are offline. Some features may be limited.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _serviceManager.refreshConnectivity();
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 16,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Simple connectivity indicator widget
class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final isOnline = snapshot.data?.any((result) => result != ConnectivityResult.none) ?? false;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isOnline ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isOnline ? Icons.wifi : Icons.wifi_off,
                color: Colors.white,
                size: 12,
              ),
              const SizedBox(width: 4),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Offline banner widget
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.orange.shade800,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You are offline',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Some features may be limited. Data will sync when you\'re back online.',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 12,
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
