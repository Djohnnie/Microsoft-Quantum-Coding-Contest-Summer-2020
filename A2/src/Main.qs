// You are given an operation that implements a two-qubit unitary transformation:
// either the identity (I ⊗ I gate), the CNOT gate (either with the first qubit as control and the second qubit as target or vice versa)
// or the SWAP gate. The operation will have Adjoint and Controlled variants defined.
//
// Your task is to perform necessary operations and measurements to figure out which unitary it was and to return
// 0 if it was the I ⊗ I gate,
// 1 if it was the CNOT12 gate,
// 2 if it was the CNOT21 gate,
// 3 if it was the SWAP gate.
//
// You are allowed to apply the given operation and its adjoint/controlled variants at most twice.
//
// You have to implement an operation which takes a two-qubit operation unitary as an input and returns an integer.
// The operation unitary will accept an array of qubits as input, but it will fail if the array is empty or has one or more than two qubits.

import Std.Convert.ResultArrayAsInt;

operation Main() : Unit
{    
    // |0110⟩
    Message($"{Solve(IXI)}");
    // |0111⟩
    Message($"{Solve(CNOT12)}");
    // |1110⟩
    Message($"{Solve(CNOT21)}");
    // |1001⟩
    Message($"{Solve(MySWAP)}");
}

operation Solve (unitary: (Qubit[] => Unit is Adj+Ctl)) : Int 
{
    // Prepare four qubits in the |0000⟩ state.
    use qs = Qubit[4];

    // Prepare the |0110⟩ state by applying the X gate to the second and third qubit.
    ApplyToEach(X, qs[1..2]);

    // Apply the two-qubit unitary transformation twice.
    // First, apply it to the first two qubits, then to the last two qubits.
    unitary(qs[0..1]);
    unitary(qs[2..3]);

    // Measure the first and last qubits.
    let b1 = MResetZ(qs[0]);
    let b2 = MResetZ(qs[3]);

    // Reset the qubits.
    MResetEachZ(qs);

    // Return an integer based on the measurement results using the little-endian format.
    return ResultArrayAsInt([b2, b1]);
}

operation IXI (qs: Qubit[]) : Unit is Adj+Ctl
{
    I(qs[0]);
    I(qs[1]);
}

operation CNOT12 (qs: Qubit[]) : Unit is Adj+Ctl
{
    CNOT(qs[0], qs[1]);
}

operation CNOT21 (qs: Qubit[]) : Unit is Adj+Ctl
{
    CNOT(qs[1], qs[0]);
}

operation MySWAP (qs: Qubit[]) : Unit is Adj+Ctl
{
    SWAP(qs[0], qs[1]);
}