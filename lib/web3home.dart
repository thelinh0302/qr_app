import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_app/metamak.dart';

class Web3Home extends StatelessWidget {
  const Web3Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: ChangeNotifierProvider(
          create: (context) => MetamaskProvider()..start(),
          builder: (context, child) {
            return Container(
              child: Center(
                child: Consumer<MetamaskProvider>(
                  builder: (context, provider, child) {
                    late final String message;
                    if (provider.isConnected && provider.isInOperatingChain) {
                      message = 'Connected';
                    } else if (provider.isConnected &&
                        !provider.isInOperatingChain) {
                      message =
                          'Wrong chain. Please connect to ${MetamaskProvider.operatingChain}';
                    } else if (provider.isEnable) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MaterialButton(
                            onPressed: () =>
                                context.read<MetamaskProvider>().connect(),
                            color: Colors.white,
                            padding: const EdgeInsets.all(0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                  width: 250,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      message = 'Please use a Web3 supported browser.';
                    }
                    return Text(
                      provider.currentAddress,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}
