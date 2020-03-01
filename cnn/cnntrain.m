function net = cnntrain(net, x, y, opts)
    m = size(x, 3);                                     % banyak data
    
    numbatches = m / opts.batchsize;                    % banyak data/batchsize harus int 
    if rem(numbatches, 1) ~= 0                          % mod
        error('numbatches not integer');
    end
    net.rL = [];                                        % empty matrix
    for i = 1 : opts.numepochs
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);
        tic;
        kk = randperm(m);                               % random val and position
        for l = 1 : numbatches
            % batch x matrix sebanyak batch size
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            % batch y label sebanyak batch size
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            net = cnnff(net, batch_x);
            net = cnnbp(net, batch_y);
            net = cnnapplygrads(net, opts);
            if isempty(net.rL)
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        toc;
    end
    
end


% m = 528;
% kk = randperm(m);
% batch_x = data_train(:, :, kk((1 - 1) * 44 + 1 : 1 * 44));