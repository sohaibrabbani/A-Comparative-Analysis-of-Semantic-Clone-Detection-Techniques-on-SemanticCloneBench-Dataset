public class XYX {
@Test

public void testFooThrowsAtFirstAndSecondTime () {

    Throwable firstException = exceptionThrownBy (new Statement () {

        public void evaluate () throws Throwable {

            foo ();

        }}

    );

    assertEquals (Exception.class, firstException.getClass ());

    Throwable secondException = exceptionThrownBy (new Statement () {

        public void evaluate () throws Throwable {

            foo ();

        }}

    );

    assertEquals (Exception.class, secondException.getClass ());

    foo ()

}

}