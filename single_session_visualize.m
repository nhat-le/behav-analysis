
animals = {'e50', 'e54', 'e57', 'f01', 'f02', 'f03', 'f04'};
id_lst = [36];
all_states = [2, 3];
for a = {'f03'} %animals
    animal = a{1};
    filedir = ['C:\Users\Cherry Wang\Dropbox (MIT)\Nhat\animalHMMData\animalData_' animal '.mat'];
%     filedir = 'C:\Users\Cherry Wang\Desktop\UROP-Nhat\HMM\animalData_f16.mat';
    load(filedir)

    states_lst = animalData.states;
    logllh_lst = animalData.logllh;
    aic_lst = animalData.aic;
    bic_lst = animalData.bic;
    maxdelays = animalData.delays;
    maxiter = animalData.maxiter;
    PSTATES_lst = animalData.PSTATES;
    sessionInfo_lst = animalData.sessionInfo;
    sessions_lst = animalData.sessions;

    figure;
    plot_id = 1;
    axeslst = [];
    state_counts = struct;
    for id = id_lst
        allchoices = animalData.sessionInfo(id).choices;
        alltargets = animalData.sessionInfo(id).targets;

        curr_state = 3;
        PSTATES = PSTATES_lst(id).states3;


        %% Visualize states of one session
%         l = subplot(numel(id_lst),1,plot_id);
%         axeslst = [axeslst l];

        EMIS_EST = sessionInfo_lst(id).(['EMIS_EST' num2str(curr_state)]);


        new_PSTATES = [EMIS_EST(:,1) PSTATES];
        order = sortrows(new_PSTATES, 1);
        new_PSTATES = order(:,2:end);
        [M, I] = max(new_PSTATES); % get all the states in the session
        new_I = [0 I 0];
        state_changes = find(diff(new_I)~=0);
        state_changes = [state_changes+1 state_changes];
        ax1 = subplot(311);
        plot(allchoices-1, 'ko', 'MarkerSize', 4)
        
        title('Underfitted HMM', 'FontSize', 15);
        ax2 = subplot(312);
        plot(allchoices-1, 'ko', 'MarkerSize', 4)
        hold on
%         plot(new_PSTATES', 'LineWidth', 2, 'Color', 'blue')
%         hold on
        graph_states = new_PSTATES';
        
        plot(graph_states(1:end,1), 'LineWidth', 2, 'Color', 'blue')
        hold on
        plot(graph_states(1:end, 2), 'LineWidth', 2, 'Color', 'cyan')
        hold on
        plot(graph_states(1:end, 3), 'LineWidth', 2, 'Color', 'yellow')
        hold on
        hold off
        
        
        colors = {'blue', 'cyan', 'yellow'};
        ax3 = subplot(313);
        plot(allchoices-1, 'ko', 'MarkerSize', 4)
        plot(graph_states(1:end,1), 'LineWidth', 2, 'Color', 'blue')
        hold on
        plot(graph_states(1:end, 2), 'LineWidth', 2, 'Color', 'cyan')
        hold on
        plot(graph_states(1:end, 3), 'LineWidth', 2, 'Color', 'yellow')
        hold on
        
        
        
        for s=1:3
            state_s = find(new_I==s);
            coords = state_changes(ismember(state_changes, state_s));
            coords = coords - 1;
            x = reshape(coords, fix(numel(coords)/2), 2);
           new_x = [x'; x'];
%             new_x = x';
            state_counts(id).(['state' num2str(s)]) = sum(new_x(2,:) - new_x(1,:))/(numel(x)/2);
            x = [new_x(1:2,:); new_x(4,:); new_x(3,:)];
            y = zeros(size(x));
            y(1:2,:) = 0;
            y(3:4,:) = 1;
            fill(x,y,colors{s},'FaceAlpha',.5);
        end
%         lgd = legend('Choices', 'State 1 (right)', 'State 2 (explore)', 'State 3 (left)');
%         lgd.FontSize = 10;
%         vline(switches, 'k--')
%         vline(subjSwitches, 'r--');
        ylim([-1 3])
        xlabel('Trials')
        plot_id = plot_id+1;

    linkaxes([ax1 ax2 ax3],'y')
    end
    
    %allavg = [state_counts.state1] + [state_counts.state2] + [state_counts.state3];
%     figure;
%     sgtitle(animal);
%     ax1=subplot(211);
    
%     plot(maxdelays, 'linewidth', 4);
%     hold on;
%     plot([state_counts.state1], 'blue');
%     hold on;
%     plot([state_counts.state2], 'cyan');
%     hold on;
%     plot([state_counts.state3], 'red');


%     ax2=subplot(212);
%     bias = ([state_counts.state3]-[state_counts.state1]);
%     plot(bias, 'linewidth', 3);
%     hold on;
%     explore = [state_counts.state2];
%     
%     noexplore = ([state_counts.state3]+[state_counts.state1])/2;
%     plot(explore-noexplore, 'linewidth', 3);
%     hold on;
%     %hline(0, 'k-');
% %     plot(noexplore, 'linewidth', 3);
%     legend('bias', 'explore');
%     
%     
%     linkaxes([ax1, ax2],'x')
end
