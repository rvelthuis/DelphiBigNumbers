#ifndef VB_OPERATORS
#define VB_OPERATORS

inline BigInteger operator +(const BigInteger& left, const BigInteger& right) {	return BigInteger::_op_Addition(left, right); }
inline BigInteger operator -(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_Subtraction(left, right); }
inline BigInteger operator *(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_Multiply(left, right); }
inline BigInteger operator *(System::Word left, const BigInteger& right) { return BigInteger::_op_Multiply(left, right); }
inline BigInteger operator /(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_IntDivide(left, right); }
inline BigInteger operator /(const BigInteger& left, System::Word right) { return BigInteger::_op_IntDivide(left, right); }
inline BigInteger operator /(const BigInteger& left, unsigned right) { return BigInteger::_op_IntDivide(left, right); }
inline BigInteger operator %(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_Modulus(left, right); }
inline BigInteger operator %(const BigInteger& left, System::Word right) { return BigInteger::_op_Modulus(left, right); }
inline BigInteger operator %(const BigInteger& left, unsigned right) { return BigInteger::_op_Modulus(left, right); }
inline BigInteger operator -(const BigInteger& value) { return BigInteger::_op_UnaryNegation(value); }
inline BigInteger operator &(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_BitwiseAnd(left, right); }
inline BigInteger operator |(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_BitwiseOr(left, right); }
inline BigInteger operator ^(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_BitwiseXOR(left, right); }
inline BigInteger operator ~(const BigInteger& value) { return BigInteger::_op_LogicalNot(value); }
inline BigInteger operator <<(const BigInteger& left, int right) { return BigInteger::_op_LeftShift(left, right); }
inline BigInteger operator >>(const BigInteger& left, int right) { return BigInteger::_op_LeftShift(left, right); }
inline bool operator ==(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_Equality(left, right); }
inline bool operator !=(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_Inequality(left, right); }
inline bool operator >(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_GreaterThan(left, right); }
inline bool operator >=(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_GreaterThanOrEqual(left, right); }
inline bool operator <(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_LessThan(left, right); }
inline bool operator <=(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_LessThanOrEqual(left, right); }

#endif
