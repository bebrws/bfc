

public class Brainfrack {
    public static void main(String[] args) {
        String printCharacterA = "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ .";
        Interpreter.evaluate(printCharacterA);
    }
}

/* TODO: exceptions for stackoverflow, accessing memory beyond MEMORY_SIZE */
class Interpreter {
    static final int MEMORY_SIZE = 30000;
    
    private static char[] memory = new char[MEMORY_SIZE];

    private static int instructionPointer = 0;
    private static int dataPointer = 0;

    public static void evaluate(String program) {
        while (true) {
            break;
        }

        printMemory();
    }

    // print the first 200 cells of memory
    private static void printMemory() {
        for (int i=0; i < 200; i++) {
                System.out.printf("%c,", memory[i]);
        }
        
        System.out.println("Done.");
        
    }
}