create or replace and compile java source named "GreekChar" as
import java.util.*;
import java.util.regex.*;

/**
 *
 * @author lubo
 */
public class GreekChar {
    private static HashMap<String, GreekChar> characters = new java.util.HashMap();
    private static HashSet<String> capsSet = new HashSet();
    private static HashSet<String> greekSet = new HashSet();
    private static HashSet<String> viSet = new HashSet();
    private static Pattern pattern;
    
    public String greek;
    public boolean fivi;
    public String greeklish;
    public boolean bi;

    private GreekChar(String greek, boolean fivi, String greeklish, boolean bi)
    {
        this.greek = greek;
        this.fivi = fivi;
        this.greeklish = greeklish;
        this.bi = bi;
    }
    
    private GreekChar(String greek, boolean fivi)
    {
        this.greek = greek;
        this.fivi = fivi;
    }
    
    private GreekChar(String greek)
    {
        this.greek = greek;
    }
    
    private GreekChar(String greek, String greeklish)
    {
        this.greek = greek;
        this.greeklish = greeklish;
    }
    
    private static void put(GreekChar cr)
    {
        characters.put(cr.greek, cr);
    }
    
    private static void put(String greek, String greeklish)
    {
        characters.put(greek, new GreekChar(greek, greeklish));
    }
    
    private static String fixCase(String text, String mirror)
    {
      String c_0 = String.valueOf(mirror.charAt(0));
      if (capsSet.contains(c_0)) {
        if (mirror.length() == 1 || capsSet.contains(String.valueOf(mirror.charAt(1)))) {
          return text.toUpperCase();
        } else {
          return String.valueOf(text.charAt(0)).toUpperCase() + (text.length()>=2 ? String.valueOf(text.charAt(1)) : "");
        }
      } 
      else 
      {
        return text;
      }
    }
    
    public static String translate(String text)
    {
        //init();
        
        if (null == text)
        {
            return null;
        }
        
        int length = text.length();
        if (0 == length)
        {
            return null;
        }

        int i_1, i_2; String c_1, c_2, replace, group;
        GreekChar gc; 
        StringBuffer sb = new StringBuffer();
        Matcher m = GreekChar.pattern.matcher(text);
        while (m.find()) {
            replace = "";
            group = m.group();
            gc = GreekChar.characters.get(group.toLowerCase());
            if (gc.bi) 
            {
                i_1 = m.start() -1;
                i_2 = m.start() +2;
                c_1 = length >= i_1 ? "" : String.valueOf(text.charAt(i_1));
                c_2 = length >= i_2 ? "" : String.valueOf(text.charAt(i_2));
                if (GreekChar.greekSet.contains(c_1) && GreekChar.greekSet.contains(c_2))
                {
                    replace = GreekChar.fixCase("mp", group);
                }
                else
                {
                    replace = GreekChar.fixCase("b", group);
                }
            } 
            else 
            {
                if (gc.fivi) 
                {
                    i_2 = m.start() +2;
                    c_1 = GreekChar.characters.get(String.valueOf(group.charAt(0)).toLowerCase()).greeklish;
                    c_2 = length <= i_2 ? "" : (GreekChar.viSet.contains(String.valueOf(text.charAt(i_2))) ? "v" : "f");
                    replace = GreekChar.fixCase(c_1 + c_2, group);
                } 
                else 
                {
                    i_1 = m.start() + group.length();
                    c_1 = i_1 < length ? String.valueOf(text.charAt(i_1)) : " ";
                    replace = GreekChar.fixCase(gc.greeklish, group + c_1);
                }
            }
            m.appendReplacement(sb, replace);
        }
        m.appendTail(sb);

        return sb.toString();
    }   

    static
    {
        /*class StrComparator implements Comparator<String>{
            @Override
            public int compare(String e1, String e2) {
                int i_1 = e1.length();
                int i_2 = e2.length();
                if (i_1 == i_2) {
                    return e1.compareToIgnoreCase(e2);
                }
                else {
                    if(i_1 < i_2){
                        return 1;
                    } else {
                        return -1;
                    }            
                }
            }
        }*/   
        
        GreekChar.put(new GreekChar("αι", "ai"));
        GreekChar.put(new GreekChar("αί", "ai"));
        GreekChar.put(new GreekChar("οι", "oi"));
        GreekChar.put(new GreekChar("οί", "oi"));
        GreekChar.put(new GreekChar("ου", "ou"));
        GreekChar.put(new GreekChar("ού", "ou"));
        GreekChar.put(new GreekChar("ει", "ei"));
        GreekChar.put(new GreekChar("εί", "ei"));
        GreekChar.put(new GreekChar("αυ", true));
        GreekChar.put(new GreekChar("αύ", true));
        GreekChar.put(new GreekChar("ευ", true));
        GreekChar.put(new GreekChar("εύ", true));
        GreekChar.put(new GreekChar("ηυ", true));
        GreekChar.put(new GreekChar("ηύ", true));
        GreekChar.put(new GreekChar("ντ", "nt"));
        GreekChar.put(new GreekChar("μπ", false, null, true));
        GreekChar.put(new GreekChar("τσ", "ts"));
        GreekChar.put(new GreekChar("τζ", "tz"));
        GreekChar.put(new GreekChar("γγ", "ng"));
        GreekChar.put(new GreekChar("γκ", "gk"));
        GreekChar.put(new GreekChar("γχ", "nch"));
        GreekChar.put(new GreekChar("γξ", "nx"));
        GreekChar.put(new GreekChar("θ" , "th"));
        GreekChar.put(new GreekChar("χ" , "ch"));
        GreekChar.put(new GreekChar("ψ" , "ps"));

        String grLetters  = "αάβγδεέζηήθιίϊΐκλμνξοόπρσςτυύϋΰφχψωώ";
        String engLetters = "aavgdeezii.iiiiklmnxooprsstyyyyf..oo";
        String chGreek, chLatin;
        for(int i = 0, l = grLetters.length(); i<l; i++)
        {
            chGreek = String.valueOf(grLetters.charAt(i));
            chLatin = String.valueOf(engLetters.charAt(i));
            if (!GreekChar.characters.containsKey(chGreek))
            {
                GreekChar.put(chGreek, chLatin);
            }
        }
        
        for(int i = 0, l = grLetters.length(); i<l; i++)
        {
            chGreek = String.valueOf(grLetters.charAt(i));
            GreekChar.greekSet.add(chGreek);
        }

        grLetters = "ΑΆΒΓΔΕΈΖΗΉΘΙΊΪΚΛΜΝΞΟΌΠΡΣΤΥΎΫΦΧΨΩΏ";
        for(int i = 0, l = grLetters.length(); i<l; i++)
        {
            chGreek = String.valueOf(grLetters.charAt(i));
            GreekChar.capsSet.add(chGreek);
        }

        grLetters = "αβγδεζηλιmμνορω";
        for(int i = 0, l = grLetters.length(); i<l; i++)
        {
            chGreek = String.valueOf(grLetters.charAt(i));
            GreekChar.viSet.add(chGreek);
        }
        
        ArrayList<String> greeks = new ArrayList();
        for(GreekChar gc : GreekChar.characters.values())
        {
            greeks.add(gc.greek);
        }
        //greeks.sort(new StrComparator());
        
        //RegEx
        //grLetters = String.join("|", greeks);
        String regEx = "";
        for(int i = 0, l = greeks.size(); i<l; i++)
        {
            if (0 < i && i <= (l-1))
            {
               regEx = regEx + "|";
            }
            regEx = regEx + greeks.get(i);
        }

        pattern = Pattern.compile(regEx, Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
    }
}
/
