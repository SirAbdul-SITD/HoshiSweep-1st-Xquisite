// lib/utils/constants.dart
import 'package:flutter/material.dart';

const Color kBg          = Color(0xFF14110C);
const Color kSurface     = Color(0xFF221C14);
const Color kBorder      = Color(0xFF3C3122);
const Color kAccent      = Color(0xFFE0B24C);
const Color kCell        = Color(0xFFEDE6D4);
const Color kCellEdge    = Color(0xFF8C8268);
const Color kShade       = Color(0xFF181410);
const Color kShadeEdge   = Color(0xFF453826);
const Color kNum         = Color(0xFF2C2418);
const Color kMark        = Color(0xFFB8A574);
const Color kErr         = Color(0xFFD8523C);
const Color kTextPrimary = Color(0xFFF3ECDA);
const Color kTextDim     = Color(0xFFAD9C78);

const Color kStarOn  = Color(0xFFFFD54F);
const Color kStarOff = Color(0xFF2A2316);

const Color kEasyColor   = Color(0xFFE0B24C);
const Color kMediumColor = Color(0xFF5AA9FF);
const Color kHardColor   = Color(0xFFFF7043);

const int kTotalLevels = 150;

TextStyle techno(double size,
        {Color color = kTextPrimary,
        FontWeight weight = FontWeight.bold,
        double letterSpacing = 1.5}) =>
    TextStyle(
        fontSize: size, color: color, fontWeight: weight,
        letterSpacing: letterSpacing);
