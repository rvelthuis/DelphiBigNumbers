#ifndef VB_OPERATORS
#define VB_OPERATORS

inline BigInteger operator +(const BigInteger& left, const BigInteger& right) { return BigInteger::Add(left, right); }
inline BigInteger operator -(const BigInteger& left, const BigInteger& right) { return BigInteger::Subtract(left, right); }
inline BigInteger operator *(const BigInteger& left, const BigInteger& right) { return BigInteger::Multiply(left, right); }
inline BigInteger operator *(System::Word left, const BigInteger& right) { return BigInteger::_op_Multiply(left, right); }
inline BigInteger operator /(const BigInteger& left, const BigInteger& right) { return BigInteger::Divide(left, right); }
inline BigInteger operator /(const BigInteger& left, System::Word right) { return BigInteger::Divide(left, right); }
inline BigInteger operator /(const BigInteger& left, unsigned right) { return BigInteger::Divide(left, right); }
inline BigInteger operator %(const BigInteger& left, const BigInteger& right) { return BigInteger::Remainder(left, right); }
inline BigInteger operator %(const BigInteger& left, System::Word right) { return BigInteger::Remainder(left, right); }
inline BigInteger operator %(const BigInteger& left, unsigned right) { return BigInteger::Remainder(left, right); }
inline BigInteger operator -(const BigInteger& value) { return BigInteger::Negate(value); }
inline BigInteger operator &(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_BitwiseAnd(left, right); }
inline BigInteger operator |(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_BitwiseOr(left, right); }
inline BigInteger operator ^(const BigInteger& left, const BigInteger& right) { return BigInteger::_op_BitwiseXOR(left, right); }
inline BigInteger operator ~(const BigInteger& value) { return BigInteger::_op_LogicalNot(value); }
inline BigInteger operator <<(const BigInteger& left, int right) { return BigInteger::_op_LeftShift(left, right); }
inline BigInteger operator >>(const BigInteger& left, int right) { return BigInteger::_op_LeftShift(left, right); }
inline bool operator ==(const BigInteger& left, const BigInteger& right) { return BigInteger::Compare(left, right) == 0; }
inline bool operator !=(const BigInteger& left, const BigInteger& right) { return BigInteger::Compare(left, right) != 0; }
inline bool operator >(const BigInteger& left, const BigInteger& right) { return BigInteger::Compare(left, right) > 0; }
inline bool operator >=(const BigInteger& left, const BigInteger& right) { return BigInteger::Compare(left, right) >= 0; }
inline bool operator <(const BigInteger& left, const BigInteger& right) { return BigInteger::Compare(left, right) < 0; }
inline bool operator <=(const BigInteger& left, const BigInteger& right) { return BigInteger::Compare(left, right) <= 0; }

#endif
