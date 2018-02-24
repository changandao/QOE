# QOE
quality of experience inspired from vmaf: https://github.com/Netflix/vmaf

VMAF – Netflix Public Database

Part A: Subjective Testing

Subjective testing on the Netflix Data using a different method: Replace the DSIS by ACR-HR
Implementation of the ACR-HR method in our QualityCrowd-Tool
Pilot study to find a suitable bitrate of the reference videos to provide pseudo-references because of bandwidth issues in Crowdsourcing
Design and planing of the Crowdsourcing experiment Statistical analysis and comparison to the Netflix ratings

Part B: Video Quality Metric

Experiment with the VMAF framework to improve the DMOS prediction:
    Possible approaches:
        Replace SVR by other methods provided in the Data Analysis lecture (PCR, PLSR ...)
        Include other video and/or image metrics (i.e. SSIM, MSSIM, IW-SSM)
        Evaluate different pooling strategies of the elementary metrics which are computed on frame level
        Analyze, visualize, compare and interpret your results to the VMAF model

