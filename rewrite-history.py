import re

def replace_author(commit):
    if commit.author_email == b"selin.ozkoc@ogr.dpu.edu.tr":
        commit.author_name = b"selinnnnnnn"
        commit.author_email = b"ozkocselin@gmail.com"
    if commit.committer_email == b"selin.ozkoc@ogr.dpu.edu.tr":
        commit.committer_name = b"selinnnnnnn"
        commit.committer_email = b"ozkocselin@gmail.com"

