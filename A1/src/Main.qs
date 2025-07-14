// You are given an operation that implements a two-qubit unitary transformation:
// either the CNOT gate with the first qubit as control and the second qubit as target (CNOT12), 
// or the CNOT gate with the second qubit as control and the first qubit as target (CNOT21).
// The operation will have Adjoint and Controlled variants defined.
//
// Your task is to perform necessary operations and measurements to figure out which unitary it was
// and to return 0 if it was the CNOT12 gate or 1 if it was the CNOT21 gate.
//
// You are allowed to apply the given operation and its adjoint/controlled variants exactly once.
//
// You have to implement an operation which takes a two-qubit operation unitary as an input and returns an integer.
// The operation unitary will accept an array of qubits as input, but it will fail if the array is empty or has one or more than two qubits.

operation Main() : Unit
{    
    Message($"{Solve(CNOT12)}");
    Message($"{Solve(CNOT21)}");
}

operation Solve (unitary: (Qubit[] => Unit is Adj+Ctl)) : Int 
{
    // Prepare two qubits in the |00⟩ state.
    use (q1, q2) = (Qubit(), Qubit());

    // Prepare the |01⟩ state by applying the X gate to the second qubit.
    X(q2);

    // Apply the two-qubit unitary transformation.
    unitary([q1, q2]);

    // Measure the first qubit in the computational basis.
    // If it remained unchanged, the unitary was CNOT12.
    // If it flipped, the unitary was CNOT21.
    let b1 = MResetZ(q1);
    MResetZ(q2);

    return b1 == Zero ? 0 | 1;
}

operation CNOT12 (qs: Qubit[]) : Unit is Adj+Ctl
{
    CNOT(qs[0], qs[1]);
}

operation CNOT21 (qs: Qubit[]) : Unit is Adj+Ctl
{
    CNOT(qs[1], qs[0]);
}