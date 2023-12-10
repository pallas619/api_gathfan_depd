part of 'widgets.dart';

class UiLoading {
  static Container loadingBlock() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: Colors.black12,
      child: const SpinKitFadingCircle(
        size: 50,
        color: Colors.purple,
      ),
    );
  }

  static Container loadingSmall() {
    return Container(
      alignment: Alignment.center,
      width: 20,
      height: 20,
      color: Colors.transparent,
      child: const SpinKitFadingCircle(
        size: 30,
        color: Color.fromARGB(255, 173, 211, 224),
      ),
    );
  }
}
