using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace PRCB.Text
{
    public static class Greeklish
    {
        private class Letter
        {
            public string Greek;

            public string Greeklish;

            public bool Fivi;

            public bool Bi;
        }

        private static readonly Dictionary<string, Letter> Letters = new Dictionary<string, Letter>(StringComparer.CurrentCultureIgnoreCase);

        private static readonly System.Text.RegularExpressions.Regex SearchPattern;

        private static readonly HashSet<char> GreekSet = new HashSet<char>();

        private static readonly HashSet<char> ViSet = new HashSet<char>();

        private static readonly HashSet<char> GrCaps = new HashSet<char>();

        static Greeklish()
        {
            var letters = new[] {
                new Letter{Greek="αι", Greeklish="ai"},
                new Letter{Greek="αί", Greeklish="ai"},
                new Letter{Greek="οι", Greeklish="oi"},
                new Letter{Greek="οί", Greeklish="oi"},
                new Letter{Greek="ου", Greeklish="ou"},
                new Letter{Greek="ού", Greeklish="ou"},
                new Letter{Greek="ει", Greeklish="ei"},
                new Letter{Greek="εί", Greeklish="ei"},
                new Letter{Greek="αυ", Fivi=true},
                new Letter{Greek="αύ", Fivi=true},
                new Letter{Greek="ευ", Fivi=true},
                new Letter{Greek="εύ", Fivi=true},
                new Letter{Greek="ηυ", Fivi=true},
                new Letter{Greek="ηύ", Fivi=true},
                new Letter{Greek="ντ", Greeklish="nt"},
                new Letter{Greek="μπ", Bi=true},
                new Letter{Greek="τσ", Greeklish="ts"},
                new Letter{Greek="τζ", Greeklish="tz"},
                new Letter{Greek="γγ", Greeklish="ng"},
                new Letter{Greek="γκ", Greeklish="gk"},
                new Letter{Greek="γχ", Greeklish="nch"},
                new Letter{Greek="γξ", Greeklish="nx"},
                new Letter{Greek="θ" , Greeklish="th"},
                new Letter{Greek="χ" , Greeklish="ch"},
                new Letter{Greek="ψ" , Greeklish="ps"}
            };

            Array.ForEach(letters, (l) => Letters.Add(l.Greek, l));

            const string grLetters  = "αάβγδεέζηήθιίϊΐκλμνξοόπρσςτυύϋΰφχψωώ";
            const string engLetters = "aavgdeezii.iiiiklmnxooprsstyyyyf..oo";

            for (var i = 0; i < grLetters.Length; i++)
            {
                var l = new Letter { Greek = grLetters[i].ToString(), Greeklish = engLetters[i].ToString() };
                if (!Letters.ContainsKey(l.Greek))
                {
                    Letters[l.Greek] = l;
                }
            }

            SearchPattern = new Regex(
                string.Join("|", Letters.Keys),
                System.Text.RegularExpressions.RegexOptions.IgnoreCase | System.Text.RegularExpressions.RegexOptions.Compiled);

            Array.ForEach(grLetters.ToArray(), c => GreekSet.Add(c));

            const string viSet = "αβγδεζηλιmμνορω";
            Array.ForEach(viSet.ToArray(), c => ViSet.Add(c));

            const string grCaps = "ΑΆΒΓΔΕΈΖΗΉΘΙΊΪΚΛΜΝΞΟΌΠΡΣΤΥΎΫΦΧΨΩΏ";
            Array.ForEach(grCaps.ToArray(), c => GrCaps.Add(c));
        }

        private static string FixCase(string text, string mirror)
        {
            var fix = text;
            if (GrCaps.Contains(mirror[0]))
            {
                if (mirror.Length == 1 || GrCaps.Contains(mirror[1]))
                {
                    fix = text.ToUpper();
                }
                else
                {
                    fix = text[0].ToString().ToUpper();
                    if (text.Length > 1)
                    {
                        fix += text.Substring(1);
                    }
                }
            }

            return fix;
        }

        public static string Translate(string greek)
        {
            return SearchPattern.Replace(greek, (m) => {
                var letter = Letters[m.Value.ToLower()];
                if (letter.Bi)
                {
                    var c1 = m.Index - 1 >= 0 ? greek[m.Index - 1].ToString().ToLower()[0] : ' ';
                    var c2 = m.Index + 2 < greek.Length ? greek[m.Index + 2].ToString().ToLower()[0] : ' ';

                    var bi = (GreekSet.Contains(c1) && GreekSet.Contains(c2)) ? "mp" : "b";

                    return FixCase(bi, m.Value);
                }
                else
                {
                    if (letter.Fivi)
                    {
                        var c1 = Letters[m.Value[0].ToString().ToLower()].Greeklish;
                        var c2 = m.Index + 2 < greek.Length ? greek[m.Index + 2].ToString().ToLower()[0] : ' ';

                        return FixCase(c1 + (ViSet.Contains(c2) ? "v" : "f"), m.Value);
                    }
                    else
                    {
                        var c1 = (m.Index + m.Value.Length) < greek.Length ? greek[m.Index + m.Value.Length].ToString() : string.Empty;
                        return FixCase(letter.Greeklish, m.Value + c1);
                    }
                }
            });
        }
    }
}