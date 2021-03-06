Init_board=[...
8 0 0 4 0 6 0 0 7;...
0 0 0 0 0 0 4 0 0;...
0 1 0 0 0 0 6 5 0;...
5 0 9 0 3 0 7 8 0;...
0 0 0 0 7 0 0 0 0;...
0 4 8 0 2 0 1 0 3;...
0 5 2 0 0 0 0 9 0;...
0 0 1 0 0 0 0 0 0;...
3 0 0 9 0 2 0 0 5];

break_point=0; //if 0 there will be no break
 

function varargout=validate_input(input,position,board)
    row=board(position(1),:);
    column=board(:,position(2));
    block=zeros(3,3);
    if position(1)>=1 & position(1)<=3 then
        i=0;
    elseif position(1)>=4 & position(1)<=6 then
        i=3;
    else
        i=6;
    end
    if position(2)>=1 & position(2)<=3 then
        j=0;
    elseif position(2)>=4 & position(2)<=6 then
        j=3;
    else
        j=6;
    end
    block=board(i+1:i+3,j+1:j+3)
 
    valid_input=%F;
    valid_row=%F;
    valid_col=%F;
    valid_block=%F;
 
    if find(input==row)==[] then
        valid_row=%T;
    end
    if find(input==column)==[] then
        valid_col=%T;
    end
    if find(input==block)==[] then
        valid_block=%T;
    end
    if valid_row & valid_col & valid_block then
        valid_input=%T;
    end
 
    varargout=list(valid_input,valid_row,valid_col,valid_block)
endfunction
 
function varargout=validate_board(board)
    valid_flag1=%T;
    for i=1:9
        for j=1:9
            if board(i,j)~= 0 then
                check_board=Init_board;
                check_board(i,j)=0;
                valid_flag1=validate_input(board(i,j),[i j],check_board);
                if ~valid_flag1 then
                    break
                end
            end
        end
        if ~valid_flag1 then
            break
        end
    end
 
    valid_flag2 = (length( find(board) ) >= 17); //enforces rule of minimum of 17 givens
                                                 //set it to always %T to ignore this rule
    valid_board = (valid_flag1 & valid_flag2);
 
    varargout=list(valid_board)
endfunction
 
disp('Initial board:');
disp(Init_board);
 
valid_init_board=validate_board(Init_board);
 
if ~valid_init_board then
    error('Invalid initial board. Should follow sudoku rules and have at least 17 clues.');
end
 
blank=[];
for i=1:9
    for j=1:9
        if Init_board(i,j)== 0 then
            blank=[blank; i j];
        end
    end
end
 
Solved_board=Init_board;
 
tic();
i=0; counter=0; breaked=%F;
while i<size(blank,'r')
    i=i+1; 
    counter=counter+1;
    pos=blank(i,:);
 
    value=Solved_board(pos(1),pos(2));
 
    valid_value=%F;
 
    while valid_value==%F
        value=value+1;
        if value>=10
            break
        else
            valid_value=validate_input(value,pos,Solved_board);
        end
    end
 
    if valid_value & value<10 then
        Solved_board(pos(1),pos(2))=value
    else
        Solved_board(pos(1),pos(2))=0;
        i=i-2;
    end
 
    if counter==break_point
        breaked=%T;
        break
    end
end
 
valid_solved_board=validate_board(Solved_board);
t2=toc();
 
if valid_solved_board & ~breaked then
    disp('Solved!');
    disp('Solution:');
    disp(Solved_board);
    disp('Time: '+string(t2)+'s.');
    disp('Steps: '+string(counter)+'.');
elseif breaked
    disp('Break point reached.');
    disp('Time: '+string(t2)+'s.');
    disp(Solved_board);
elseif ~valid_solved_board & ~breaked
    disp('Invalid solution found.');
    disp(Solved_board);
end
