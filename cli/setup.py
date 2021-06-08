from setuptools import setup

setup(
    name="gst",
    version="1.0",
    include_package_data=True,
    install_requires=["click"],
    py_modules=['gst'],
    entry_points={
        'console_scripts': [
            'gst = gst:cli',
        ],
    },
)
