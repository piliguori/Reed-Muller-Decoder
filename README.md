# ReedMuller

VHDL implementation of Reed-Muller Coder and Decoder.

The Reed-Muller Code is used in PUF-based authentication protocol such an error-correction technique. In the Enrollment Phase it is used to encode secret random number cs to Cs, while in the Verification Phase it is used to decode the noisy version Cs'. The main feature of this component is that it is completely generic and customizable. The decoder is based on a majority voter, created using a parallel counter block, a generic adder and a generic comparator.

This project was developed for Secure System Design exam (University of Naples Federico II - Computer Engineering) in collaboration with https://github.com/AlfonsoDiMartino and https://github.com/SalvatoreBarone
