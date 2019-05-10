import java.util.*;

public class Gen {

  public static LinkedList<Instr> code = LLE.add_elem(
    new BinOp(
      new PairV(new IntV(2), new IntV(5)),
      BinOp.Operator.ADD
    ),
    LLE.empty()
  );
}

// new Quote(new PairV(new IntV(2), new NullV()))
