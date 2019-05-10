import java.util.*;

class BoolV extends Value {

  boolean b;

  /* Constructors */
  public BoolV (boolean b) {
    this.b = b;
  }

  boolean get_bool() {
    return this.b;
  }

  void set_bool(boolean nb) {
    this.b = nb;
  }

  void print_value() {
    System.out.print(this.b);
  }
}
