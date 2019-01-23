BitUtil = {}
bit =require "bit"
BitUtil.data32= {} 
for i=1,32 do  
    BitUtil.data32[i]=2^(32-i)
end

local int32= {} 
for i=0,31 do  
    int32[i]=2^i
end

--num 10进制的32位int, index 第几位0-31
--返回：num大于index位代表的值，则为true，反之为false
--ex: BitUtil.valid(128,5) 返回true  BitUtil.valid(4,5) 返回false
function BitUtil.valid(num,index)
    return num >= int32[index]
end

--num 10进制的32位int, index 第几位0-31
--返回：若index位上有值，则返回位相应的值，否则返回0
function BitUtil.band(num,index)
    return bit.band(num,int32[index])
end

--num 10进制的32位int, index 第几位0-31
--返回：若index位上有值，则返回1，否则返回0
function BitUtil.bandOneZero(num,index)
    return bit.band(num,int32[index])>0 and 1 or 0
end

--num 10进制的32位int, index 第几位0-31
--返回：若index位上有值，则返回位相应的值，否则返回0
function BitUtil.bor(num,index)
    return bit.bor(num,int32[index])
end

--num 10进制的32位int, index 第几位0-31
--返回：位上设置1，返回int
function BitUtil.setbit(num,index)
    return BitUtil.band(num,index)>0 and num or num + int32[index]
end

--num 10进制的32位int, index 第几位0-31
--返回：位上设置0，返回int
function BitUtil.unsetbit(num,index)
    return BitUtil.band(num,index)<=0 and num or num - int32[index]
end

--传入一个32位整数
function BitUtil.d2b(arg)  
    arg = arg or 0
    local bits ={}  
    for i=1,32 do  
        if arg >= BitUtil.data32[i] then  
            bits[i]=1  
            arg=arg-BitUtil.data32[i]  
        else  
            bits[i]=0  
        end  
    end  
    return bits 
end  

function BitUtil.b2d(arg)  
    local nr=0  
    for i=1,32 do  
        if arg[i] ==1 then  
        nr=nr+2^(32-i)
        end  
    end  
    return  nr  
end

-- function BitUtil.xor(a,b)  
--     local   op1=BitUtil.d2b(a)  
--     local   op2=BitUtil.d2b(b)  
--     local   r={}  
  
--     for i=1,32 do  
--         if op1[i]==op2[i] then  
--             r[i]=0  
--         else  
--             r[i]=1  
--         end  
--     end  
--     return  BitUtil.b2d(r)  
-- end --bit:xor  
  
-- function BitUtil.and(a,b)  
--     local   op1=BitUtil.d2b(a)  
--     local   op2=BitUtil.d2b(b)  
--     local   r={}  
      
--     for i=1,32 do  
--         if op1[i]==1 and op2[i]==1  then  
--             r[i]=1  
--         else  
--             r[i]=0  
--         end  
--     end  
--     return  BitUtil.b2d(r)  
      
-- end --bit:_and  
  
-- function BitUtil.or(a,b)  
--     local   op1=BitUtil.d2b(a)  
--     local   op2=BitUtil.d2b(b)  
--     local   r={}  
      
--     for i=1,32 do  
--         if  op1[i]==1 or   op2[i]==1   then  
--             r[i]=1  
--         else  
--             r[i]=0  
--         end  
--     end  
--     return  BitUtil.b2d(r)  
-- end --bit:_or  
  
-- function BitUtil._not(a)  
--     local   op1=BitUtil.d2b(a)  
--     local   r={}  
  
--     for i=1,32 do  
--         if  op1[i]==1   then  
--             r[i]=0  
--         else  
--             r[i]=1  
--         end  
--     end  
--     return BitUtil.b2d(r)  
-- end --bit:_not  
  
-- function BitUtil.rshift(a,n)  
--     local   op1=BitUtil.d2b(a)  
--     local   r=BitUtil.d2b(0)  
      
--     if n < 32 and n > 0 then  
--         for i=1,n do  
--             for i=31,1,-1 do  
--                 op1[i+1]=op1[i]  
--             end  
--             op1[1]=0  
--         end  
--     r=op1  
--     end  
--     return  BitUtil.b2d(r)  
-- end --bit:_rshift  
  
function BitUtil.lshift(a,n)  
    local   op1=BitUtil.d2b(a)  
    local   r=BitUtil.d2b(0)  
      
    if n < 32 and n > 0 then  
        for i=1,n   do  
            for i=1,31 do  
                op1[i]=op1[i+1]  
            end  
            op1[32]=0  
        end  
    r=op1  
    end  
    return BitUtil.b2d(r)  
end --bit:_lshift  