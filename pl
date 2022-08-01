using System;
using System.Collections.Generic;
using System.Linq;
using System.Diagnostics;

namespace pokerlib
{
    public enum Rank
    {
        Two = 2,
        Three = 3,
        Four = 4,
        Five = 5,
        Six = 6,
        Seven = 7,
        Eight = 8,
        Nine = 9,
        Ten = 10,
        J = 11,
        Q = 12,
        K = 13,
        A = 14
    }
    public enum Suit
    {
        S,
        H,
        C,
        D
    }

    public class Hand : IComparable<Hand>
    {
        public List<Card> CardList;
        public string HandString;
        public int Score;
        public int RankBonus;

        public int CompareTo(Hand hand)
        {
            int result = Score.CompareTo(hand.Score);
            if (result != 0)
            {
                return result;
            }
            result = RankBonus.CompareTo(hand.RankBonus);
            if (result != 0)
            {
                return result;
            }

            for (int i = 0; i < CardList.Count; i++)
            {
                result = CardList[i].CompareTo(hand.CardList[i]);
                if (result < 0)
                {
                    return result;
                }
            }
            return result;
        }
        public  bool FiveOfAKind()
        {
            if (NOfAKind(5))
            {
                return true;
            }
            else if (CardList.Count(card => card.RankState == Rank.A) == 4 && CardList.Any(card => card.RankState == Rank.J))
            {
                RankBonus = (int)Rank.A;
                return true;
            }
            return false;
        }
        public  bool Straight()
        {

            IEnumerable<int> desired = Enumerable.Range(CardList.Min(card => (int)card.RankState),CardList.Count).Reverse();
            if (CardList.Select(card => (int)card.RankState).SequenceEqual(desired))
            {

                RankBonus = (int)CardList.Max().RankState;
                return true;
            }

            else if (CardList.Select(card => (int)card.RankState).ToList().SequenceEqual(new List<int> { 14, 5, 4, 3, 2 }))
            {
                RankBonus = 5;
                return true;
            }
            return false;
        }
        public  bool NOfAKind( int num)
        {
            foreach (Card card in CardList)
            {
                if (CardList.Count(foo => foo.RankState == card.RankState) == num)
                {
                    RankBonus = (int)card.RankState;
                    return true;
                }
            }
            return false;

        }
        public  bool Flush()
        {
            /*foreach (Suit suitState in CardList.Select(card => card.SuitState))
            {
                if (suitState != CardList.Select(card => card.SuitState).First())
                {
                    return false;
                }
            }
           */
            if (CardList.Select(card => card.SuitState).Distinct().Count() == 1)
            {
                RankBonus = (int)CardList.Max().RankState;
                return true;

            }
            return false;
        }
        public  bool TwoPair()
        {
            List<int> pairs = new List<int>();
            foreach (Card card in CardList)
            {
                if (CardList.Count(foo => foo.RankState == card.RankState) == 2)
                {
                    Debug.WriteLine($"Occurences of {card.RankState}:{CardList.Count(foo => foo.RankState == card.RankState)}");

                    if (!pairs.Contains((int)card.RankState))
                    {
                        pairs.Add((int)card.RankState);
                    }
                }

            }
            if (pairs.Count == 2)
            {
                RankBonus = pairs.Max();
                return true;
            }
            return false;
        }
        public  bool IsWinnerHand( List<Hand> handList)
        {

            for (int i = 0; i < handList.Count; i++)
            {
                if (handList[i] != this)
                {
                    if (this.CompareTo(handList[i]) < 0)
                    {
                        return false;
                    }

                }

            }
            return true;

        }
        public  void AssignScores()
        {
            CardList.Sort();
            CardList.Reverse();
            if (FiveOfAKind())
            {
                Score = 10;
                Debug.WriteLine("Five Of A Kind");
                return;
            }
            else if (Flush() && Straight())
            {
                Score = 9;
                Debug.WriteLine("Straight Flush");
                return;
            }
            else if (NOfAKind(4))
            {
                Score = 8;
                Debug.WriteLine("Four of A Kind");
                return;

            }
            else if (NOfAKind(2) && NOfAKind(3))
            {
                Score = 7;
                Debug.WriteLine("Full House");
                return;

            }
            else if (Flush())
            {
                Score = 6;
                Debug.WriteLine("Flush");
                return;

            }
            else if (Straight())
            {
                Score = 5;
                Debug.WriteLine("Straight");
                return;

            }
            else if (NOfAKind(3))
            {
               Score = 4;
                Debug.WriteLine("Three of a Kind");
                return;

            }
            else if (TwoPair())
            {
                Score = 3;
                Debug.WriteLine("Two pair");
                return;

            }
            else if (NOfAKind(2))
            {
                Score = 2;
                Debug.WriteLine("One Pair");
                return;

            }
            else
            {
                Score = 1;
                RankBonus = (int)CardList.Max().RankState;
                Debug.WriteLine("High Card");
                return;

            }
        }

    }
    public struct Card : IComparable<Card>
    {
        public Rank RankState;
        public Suit SuitState;
        public int CompareTo(Card card)
        {
            return RankState.CompareTo(card.RankState);
        }
        public override string ToString()
        {
            if ((int)RankState > 10)
            {

                return $"{RankState.ToString()}{SuitState.ToString()}";
            }
            else
            {
                return $"{(int)RankState}{SuitState.ToString()}";
            }
        }

    }

}
