public class XYX {
public void run () {

    try {

        for (int i = 0;

        i < 5; i ++) {

            world.acquire ();

            System.out.println ("  World!");

            hello.release ();

        }

    } catch (InterruptedException e) {

        e.printStackTrace ();

    }

}

}