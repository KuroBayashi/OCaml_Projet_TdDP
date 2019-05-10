import java.util.*;

class IntV extends Value {

  int i;

  /* Constructors */
  public IntV (int i) {
    this.i = i;
  }

  int get_int() {
    return this.i;
  }
  
  void set_int(int ni) {
    this.i = ni;
  }

  void print_value() {
    System.out.print(this.i);
  }
}
