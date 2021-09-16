% For visualizing the block structures from an animal through training
filedir = 'C:\Users\Cherry Wang\Dropbox (MIT)\Nhat\animalHMMData\animalData_f03.mat';
% filedir = 'C:\Users\Cherry Wang\Desktop\UROP-Nhat\HMM\animalData_f01.mat';
load(filedir)
name = animalData.name;

% Determine the states
statesArr = {animalData.PSTATES.states3};
maxArr = cell(numel(statesArr), 1);
emisAll = {animalData.sessionInfo.EMIS_EST3};
order = find_state_order(emisAll);
probs = find_state_probs(emisAll);
permutedAll = cell(numel(statesArr), 1);
probsAll = cell(numel(statesArr), 1);


for i = 1:numel(statesArr)
	maxstates = get_currstate(statesArr{i});
    maxArr{i} = maxstates;
end

% Perform the permutation
for i = 1:numel(maxArr)
%     disp(i)
    single_arr = maxArr{i};
%     disp(single_arr)
    
    % Permute
    permuted = single_arr;
    single_prob = single_arr;
    
    curr_order = order(:,i);
    curr_prob = probs(:,i);
    permuted(single_arr == 1) = curr_order(1);
    permuted(single_arr == 2) = curr_order(2);
    permuted(single_arr == 3) = curr_order(3);
    single_prob(single_arr == 1) = curr_prob(1);
    single_prob(single_arr == 2) = curr_prob(2);
    single_prob(single_arr == 3) = curr_prob(3);
    
    
    
    permutedAll{i} = permuted;
    probsAll{i} = single_prob;
end




%% Assemble the permuted states
maxlen = max(cellfun(@(x) numel(x), permutedAll));
aggStates = nan(numel(maxArr), maxlen);
for i = 1:numel(permutedAll)
    aggStates(i, 1:numel(permutedAll{i})) = permutedAll{i};
end

aggStates(isnan(aggStates)) = 4;

delay_rep = reshape(animalData.delays, numel(animalData.delays), 1);


%% Plot
figure;
ax1 = subplot(121);
imagesc(aggStates);
title('HMM across sessions back at no delay');
xlabel('Trials')
ylabel('Session')
set(gca, 'FontSize', 12)
colormap jet

%%
ax2 = subplot(122);
d_delays = diff(animalData.delays);
d_delays = [0 d_delays];
sessions = 1:numel(animalData.delays);
% plot(animalData.delays);
plot(animalData.delays, sessions)
set(gca, 'YDir','reverse')
title('Delays applied across sessions')

linkaxes([ax1, ax2], 'y')

%%
figure; 
state1 = aggStates == 1;
state2 = aggStates == 2;
state3 = aggStates == 3;
ax3 = subplot(211);
plot(find_average(aggStates, 1), 'LineWidth', 2);
hold on
% plot(find_average(aggStates, 2), 'LineWidth', 2);

hold on
plot(find_average(aggStates, 3), 'LineWidth', 2);
hold off
title('Average duration of exploration');
xlabel('Sessions');
ylabel('Trials');

% legend('Right state', 'Exploratory state', 'Left state');
ax4 = subplot(212);
plot(animalData.delays);
xlabel('Sessions');
ylabel('Delays (sec)');
linkaxes([ax3, ax4], 'x')

title('Delays across sessions');

function state_avg_len = find_average(aggStates, state_num)
    state_logical = aggStates == state_num;
    states_sum = sum(state_logical, 2);
    state_changes = state_logical(:,1);
    state_changes = double(state_changes);
    for i = 1:numel(state_changes)
        stuff = find(diff(state_logical(i,:)) ~=0);
        state_changes(i) = (numel(stuff) +1)/2;
    end
    state_avg_len = states_sum./state_changes;

end
function maxstates = get_currstate(arr)
% get the current state
[~, argmax] = max(arr);
maxstates = argmax;
end


function order = find_state_order(emisAll)
emisArr = cell2mat(emisAll);
emisArr = emisArr(:,1:2:end);

% Find the permutations of the states
[~,orderpre] = sort(emisArr);
[~,order] = sort(orderpre);
end


function probs = find_state_probs(emisAll)
emisArr = cell2mat(emisAll);
probs = emisArr(:,1:2:end);

end

function visualize_cell(arr, name)
maxlen = max(cellfun(@(x) numel(x), arr));
aggStates = nan(numel(arr), maxlen);
for i = 1:numel(arr)
    aggStates(i, 1:numel(arr{i})) = arr{i};
end

aggStates(isnan(aggStates)) = 4;


%% Plot
% figure;
% imagesc(aggStates * 2 - 1);
% title(name);
% xlabel('Trials')
% ylabel('Session')
% set(gca, 'FontSize', 16)
% % colormap(bluewhitered(256))
% caxis([-1,1])
% colormap(jet)


end