LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
package mypack is

	subtype BCD is integer range 0 to 9;
	subtype SSD	is STD_LOGIC_VECTOR(0 TO 6);

	constant dim : SSD := "1111111";
	constant char0 : SSD := "0000001";		--0
	constant char1 : SSD := "1001111";		--1
	constant char2 : SSD := "0010010";		--2
	constant char3 : SSD := "0000110";		--3
	constant char4 : SSD := "1001100";		--4
	constant char5 : SSD := "0100100";		--5
	constant char6 : SSD := "0100000";		--6
	constant char7 : SSD := "0001111";		--7
	constant char8 : SSD := "0000000";		--8
	constant char9 : SSD := "0000100";		--9
	type SSD_TYPS is array (0 to 10) of SSD;
	constant SSD_DATA : SSD_TYPS :=
		(char0,
		 char1,
		 char2,
		 char3,
		 char4,
		 char5,
		 char6,
		 char7,
		 char8,
		 char9,
		 dim
		 );	
end mypack;
