function[mmd] = MMD(set1,set2,s)
%输入两个sample set，s是gaussian kernel的sigma
[n1,d1] = size(set1);
[n2,d2] = size(set2);

mmd = 0;

first_part = 0;
for i=1:n1
   for j=1:n1
       if(i==j)
          continue; 
       end
       first_part = first_part + gaussian_kernel(set1(i,:),set1(j,:),s);
   end
end
first_part = first_part/(n1*(n1-1));

second_part = 0;
for i=1:n2
   for j=1:n2
       if(i==j)
          continue; 
       end
       second_part = second_part + gaussian_kernel(set2(i,:),set2(j,:),s);
   end
end
second_part = second_part/(n2*(n2-1));

third_part = 0;
for i=1:n1
   for j=1:n2
      third_part = third_part + gaussian_kernel(set1(i,:),set2(j,:),s); 
   end
end
third_part = 2*third_part/(n1*n2);

mmd = first_part+second_part-third_part;