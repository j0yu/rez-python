name = 'python'

__version__ = '3.7.4'
version = __version__

build_command = r'''
docker build --rm \
    --build-arg VERSION="{version}" \
    --build-arg INSTALL_DIR="{install_dir}" \
    -t local/python \
    $REZ_BUILD_SOURCE_PATH

if [ $REZ_BUILD_INSTALL -eq 1 ]
then
    CONTAINTER_ID=$(docker run --rm -td local/python)
    docker cp $CONTAINTER_ID:{install_dir}/. {install_dir}
    docker stop $CONTAINTER_ID
fi
'''.format(
    version=__version__,
    install_dir='${{REZ_BUILD_INSTALL_PATH:-/usr/local}}',
)

def commands():
    import os.path
    env.PATH.append(os.path.join('{root}', 'bin'))
    env.LD_LIBRARY_PATH.append(os.path.join('{root}', 'lib'))
