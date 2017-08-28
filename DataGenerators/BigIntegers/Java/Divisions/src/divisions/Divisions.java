/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package divisions;

import java.math.BigDecimal;

public class Divisions 
{
    public static void main(String[] args) 
    {
        double d1 = 1.0;
        double d2 = d1 / 3.0;
        double d3 = d2 * 3.0;
        BigDecimal b1 = BigDecimal.valueOf(d2);
        
        System.out.println(b1.toPlainString());
        
        double d4 = 0.33333333333333;
        double d5 = 3.0 * d4;
        BigDecimal b2 = BigDecimal.valueOf(d4);
        
        System.out.println(b2.toPlainString());
        
    }
    
}
