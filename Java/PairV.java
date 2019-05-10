import java.util.*;

class PairV extends Value {
  Value x;
  Value y;

  /* Constructors */
  public PairV (Value x, Value y) {
    this.x = x;
    this.y = y;
  }

  Value get_x() {
    return this.x;
  }
  
  Value get_y() {
    return this.y;
  }

  void set_x(Value nx) {
    this.x = nx;
  }
  
  void set_y(Value ny) {
    this.y = ny;
  }

  void print_value() {
    System.out.print("(");
      this.x.print_value();
    System.out.print(",");
      this.y.print_value();
    System.out.print(")");
  }
}
