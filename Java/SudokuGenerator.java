import java.util.Random;
import java.util.HashSet;

public class SudokuGenerator {

    private int[][] grid;
    private Random random;

    public SudokuGenerator() {
        grid = new int[9][9];
        random = new Random();
    }

    public void generate() {
        fillDiagonalBoxes();
        removeCells(30); // Remove 30 cells to create the puzzle
    }

    private void fillDiagonalBoxes() {
        for (int i = 0; i < 9; i += 3) {
            fillBox(i, i);
        }
    }

    private void fillBox(int row, int col) {
        HashSet<Integer> usedNumbers = new HashSet<>();
        int num;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                do {
                    num = random.nextInt(9) + 1;
                } while (usedNumbers.contains(num));
                usedNumbers.add(num);
                grid[row + i][col + j] = num;
            }
        }
    }

    private void removeCells(int count) {
        while (count > 0) {
            int row = random.nextInt(9);
            int col = random.nextInt(9);
            if (grid[row][col] != 0)
                grid[row][col] = 0;
                count--;
        }
    }

    public void printGrid() {
        for (int i = 0; i < 9; i++) {
            if (i % 3 == 0 && i != 0) {
                System.out.println("------+-------+------");
            }
            for (int j = 0; j < 9; j++) {
                if (j % 3 == 0 && j != 0) {
                    System.out.print("| ");
                }
                if (grid[i][j] == 0) {
                    System.out.print("  "); // Print two spaces for blank cells
                } else {
                    System.out.print(grid[i][j] + " ");
                }
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        SudokuGenerator generator = new SudokuGenerator();
        generator.generate();
        generator.printGrid();
    }
}