// You are given an operation that implements a single-qubit unitary transformation:
// either the H gate or the X gate. The operation will have Adjoint and Controlled variants defined.
//
// Your task is to perform necessary operations and measurements to figure out which unitary it was
// and to return 0 if it was the H gate or 1 if it was the X gate.
//
// You are allowed to apply the given operation and its adjoint/controlled variants at most twice.
//
// You have to implement an operation which takes a single-qubit operation as an input and returns an integer.

operation Main() : Unit
{    
    Message($"{Solve(H)}");
    Message($"{Solve(X)}");
}

operation Solve (unitary: (Qubit => Unit is Adj+Ctl)) : Int 
{
    // Prepare a qubit in the |0⟩ state.
    use q = Qubit();
    
    // Apply the single-qubit unitary transformation the first time.
    unitary(q);

    // Apply the Z-gate to the qubit.
    Z(q);
    
    // Apply the single-qubit unitary transformation the second time.
    unitary(q);

    // Measure the qubit in the computational basis.
    // If it is in the |1⟩ state, the unitary was H:
    // |0⟩ → H → |+⟩ → Z → |-⟩ → H → |1⟩
    // If it is in the |0⟩ state, the unitary was X:
    // |0⟩ → X → |1⟩ → Z → |1⟩ → X → |0⟩
    return MResetZ(q) == One ? 0 | 1;
}