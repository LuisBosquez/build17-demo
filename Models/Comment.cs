using System;

namespace build17_demo.Models
{
    public class Comment
    {
        public int CommentId { get; set; }
        public String Text { get; set; }
        public String Author { get; set; }

        public override string ToString()
        {
            return String.Format("{0}: '{1}'. ({2})", CommentId, Text, Author);
        }
    }
}