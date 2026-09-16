int countWorkDays(String workDays) {
  if (workDays.isEmpty) return 0;
  // نفترض أن كل يوم عبارة عن 3 أحرف مثل "Sun" أو "Mon"
  return workDays.length ~/ 3;
}
