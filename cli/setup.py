from setuptools import setup

setup(
    name='gst',
    version='1.0.0',
    py_modules=['gst'],
    packages=['backup'],
    include_package_data=True,
    install_requires=[
        'Click',
    ],
    entry_points={
        'console_scripts': [
            'gst = gst:cli',
        ],
    },
)
