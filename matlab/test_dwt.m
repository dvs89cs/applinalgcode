test_dwt_different_sizes()
test_kernel_ortho()
test_orthogonality()
test_kernel( 'cdf97')
test_kernel( 'cdf53')
test_kernel( 'pwl0')
test_kernel( 'pwl2')
test_kernel( 'haar')
    
function test_kernel(wave_name)
    disp(sprintf('Testing %s, 1D', wave_name))
    res = rand(16,1);
    x = res;
    x = dwt_impl(x, wave_name, 2);
    x = idwt_impl(x, wave_name, 2);
    diff = max(abs(x-res));
    assert(diff < 1E-13)
    
    disp(sprintf('Testing %s, 2D', wave_name))
    res = rand(16,2);
    x = res;
    x = dwt_impl(x, wave_name, 2);
    x = idwt_impl(x, wave_name, 2);
    diff = max(max(abs(x-res)));
    assert(diff < 1E-13)
end
    
function test_kernel_ortho()
    disp('Testing orthonormal wavelets')
    res = rand(16,1); % only this assumes that N is even
    
    disp('Testing that the reverse inverts the forward transform')
    x = res;
    x = dwt_impl(x, 'db4', 2);
    x = idwt_impl(x, 'db4', 2);
    diff = max(abs(x-res));
    assert(diff ~= 0 && diff < 1E-13)
    
    disp('Testing that the transform is orthogonal, i.e. that the transform and its dual are equal')
    x = res;
    x = dwt_impl(x, 'db4', 2, 'per');
    res = dwt_impl(res, 'db4', 2, 'per', 'none', 0, 1);
    diff = max(abs(x-res));
    assert(diff ~= 0 && diff < 1E-13)
end
    
function test_dwt_different_sizes()
    disp('Testing the DWT on different input sizes')
    m = 4;

    disp('Testing the DWT for greyscale image')
    img = rand(32);
    img2 = img;
    img2 = dwt_impl(img2, 'cdf97', m, 'symm', 'none', 2);
    img2 = idwt_impl(img2, 'cdf97', m, 'symm', 'none', 2);
    diff = max(max(abs(img2-img)));
    assert(diff ~= 0 && diff < 1E-13)
    
    disp('Testing the DWT for RGB image')
    img = rand(32, 32, 3);
    img2 = img;
    img2 = dwt_impl(img2, 'cdf97', m);
    img2 = idwt_impl(img2, 'cdf97', m);
    diff = max(max(max(abs(img2-img))));
    assert(diff ~= 0 && diff < 1E-13)
    
    disp('Testing the DWT for sound with one channel')
    sd = rand(32,1);
    sd2 = sd;
    sd2 = dwt_impl(sd2, 'cdf97', m);
    sd2 = idwt_impl(sd2, 'cdf97', m);
    diff = max(abs(sd2-sd));
    assert(diff ~= 0 && diff < 1E-13)
    
    disp('Testing the DWT for sound with two channels')
    sd = rand(32,2);
    sd2 = sd;
    sd2 = dwt_impl(sd2, 'cdf97', m);
    sd2 = idwt_impl(sd2, 'cdf97', m);
    diff = max(max(abs(sd2-sd)));
    assert(diff ~= 0 && diff < 1E-13)
    
    disp('Testing 3D with one channel')
    sd = rand(32,32,32);
    sd2 = sd;
    sd2 = dwt_impl(sd2, 'cdf97', m, 'symm', 'none', 3);
    sd2 = idwt_impl(sd2, 'cdf97', m, 'symm', 'none', 3);
    diff = max(max(max(abs(sd2-sd))));
    assert(diff ~= 0 && diff < 1E-13)
    
    disp('Testing 3D with two channels')
    sd = rand(32,32,32,3);
    sd2 = sd;
    sd2 = dwt_impl(sd2, 'cdf97', m);
    sd2 = idwt_impl(sd2, 'cdf97', m);
    diff = max(max(max(max(abs(sd2-sd)))));
    assert(diff ~= 0 && diff < 1E-13)
end
    
function test_orthogonality()
    disp('Testing that the wavelet and the dual wavelet are equal for orthonormal wavelets')
    x0 = rand(32,1);
    
    disp('Testing that the IDWT inverts the DWT')
    x = x0;
    x = dwt_impl(x, 'db4', 2, 'per');
    x = idwt_impl(x, 'db4', 2, 'per');
    diff = max(abs(x-x0));
    assert(diff ~= 0 && diff < 1E-13)

    disp('See that the wavelet transform equals the dual wavelet transform')
    x = x0;
    x = dwt_impl(x, 'db4', 2, 'per', 'none', 0, 1);
    x0 = dwt_impl(x0, 'db4', 2, 'per', 'none', 0, 0);
    diff = max(abs(x-x0));
    assert(diff ~= 0 && diff < 1E-13)

    disp('Apply the transpose, to see that the transpose equals the inverse')
    x = x0;
    x = dwt_impl(x, 'db4', 2, 'per', 'none', 0, 0, 1);
    x = dwt_impl(x, 'db4', 2, 'per', 'none', 0, 0, 0);
    diff = max(abs(x-x0));
    assert(diff ~= 0 && diff < 1E-13)
end