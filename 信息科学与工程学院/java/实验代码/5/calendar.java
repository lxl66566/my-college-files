import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

public class calendar {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("请输入年份和月份（如 2012/5）：");
        String input = scanner.nextLine().trim();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/" + (input.length() < 7 ? "M" : "MM"));
        YearMonth yearMonth = YearMonth.parse(input, formatter);
        LocalDate date = yearMonth.atDay(1);
        System.out.println("一\t二\t三\t四\t五\t六\t日");
        for (int i = 1; i < date.getDayOfWeek().getValue(); i++) {
            System.out.print("\t");
        }
        while (date.getMonthValue() == yearMonth.getMonthValue()) {
            System.out.print(date.getDayOfMonth() + "\t");
            if (date.getDayOfWeek().getValue() == 7) {
                System.out.println();
            }
            date = date.plusDays(1);
        }
        scanner.close();
    }
}