import 'package:flutter_opencv_dlib/src/face_points.dart';

enum Expression { happy, sad, neutral, angry, surprised }

Expression detectExpression(FacePoints points) {
  // Asumimos que los puntos faciales están en el formato esperado (68 puntos).
  if (points.nFacePoints != 68) return Expression.neutral;

  // Extraemos los puntos relevantes para detectar las expresiones.
  final leftEye = points.points.sublist(36 * 2, 42 * 2);
  final rightEye = points.points.sublist(42 * 2, 48 * 2);
  final mouth = points.points.sublist(48 * 2, 68 * 2);

  // Calculamos las distancias relevantes y sus proporciones.
  double eyeAspectRatio(List<int> eye) {
    double vertical1 = _distance(eye[1 * 2], eye[1 * 2 + 1], eye[5 * 2], eye[5 * 2 + 1]);
    double vertical2 = _distance(eye[2 * 2], eye[2 * 2 + 1], eye[4 * 2], eye[4 * 2 + 1]);
    double horizontal = _distance(eye[0 * 2], eye[0 * 2 + 1], eye[3 * 2], eye[3 * 2 + 1]);
    return (vertical1 + vertical2) / (2.0 * horizontal);
  }

  double mouthAspectRatio(List<int> mouth) {
    double vertical = _distance(mouth[3 * 2], mouth[3 * 2 + 1], mouth[9 * 2], mouth[9 * 2 + 1]);
    double horizontal = _distance(mouth[0 * 2], mouth[0 * 2 + 1], mouth[6 * 2], mouth[6 * 2 + 1]);
    return vertical / horizontal;
  }

  double _distance(int x1, int y1, int x2, int y2) {
    return ((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)).toDouble();
  }

  double leftEAR = eyeAspectRatio(leftEye);
  double rightEAR = eyeAspectRatio(rightEye);
  double mar = mouthAspectRatio(mouth);

  // Thresholds basados en la geometría facial.
  if (leftEAR < 0.2 && rightEAR < 0.2) {
    return Expression.surprised;
  } else if (mar > 0.5) {
    return Expression.happy;
  } else if (mar < 0.3) {
    return Expression.sad;
  } else if (leftEAR > 0.3 && rightEAR > 0.3) {
    return Expression.angry;
  }

  return Expression.neutral;
}
