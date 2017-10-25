using System;
using System.Data;
using System.Web.UI.WebControls;

namespace RESTgithubissues
{
    public partial class DatePicker : System.Web.UI.Page
    {
        DateTime ctselecteddate;
        DateTime nullDate = new DateTime(1, 1, 1);
        DataTable dt = new DataTable();
        bool indate = false;
        System.Collections.ArrayList al = new System.Collections.ArrayList();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ctselecteddate = DateTime.Now;
                this.Calendar1.VisibleDate = ctselecteddate;
                ctdate.Value = Request["cdt"] + "";
            }
            if (ctdate.Value.Length > 0)
                if (DateTime.TryParse(ctdate.Value, out ctselecteddate))
                {
                    this.Calendar1.VisibleDate = ctselecteddate;
                    indate = true;
                }

            if (!IsPostBack)
            {
                DateTime d1 = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 01); // go back 1 week
                DateTime d2 = d1;

                buildmonthsyears(ref ddlyears, ref ddlmonths, Calendar1.VisibleDate.Date, ctdob.Value);
            }
            // color
            Calendar1.TitleStyle.CssClass = "calMonth_" + Calendar1.VisibleDate.Month.ToString();
        }

        protected void Page_UnLoad(object sender, EventArgs e)
        {
            if (dt != null)
                dt.Dispose();
        }

        protected void Calendar1_DayRender(object sender, DayRenderEventArgs e)
        {
            if (e.Day.Date == DateTime.Now.Date)
            {
                e.Cell.BorderWidth = new Unit(2);
                Literal lit1 = new Literal();
                lit1.Text = "&nbsp;TODAY";
                e.Cell.Controls.Add(lit1);
            }
            if (indate && e.Day.Date == ctselecteddate)
            {
                e.Cell.BorderWidth = new Unit(2);
                e.Cell.BorderColor = System.Drawing.Color.BlueViolet;
            }



        }

        protected void Calendar1_SelectionChanged(object sender, EventArgs e)
        {
            this.txtdate.Text = Calendar1.SelectedDate.ToShortDateString();
        }

        private void calendarset()
        {
            DateTime d1 = new DateTime(Calendar1.VisibleDate.Year, Calendar1.VisibleDate.Month, 01); // 1st
            DateTime d2 = d1;
            // color
            Calendar1.TitleStyle.CssClass = "calMonth_" + Calendar1.VisibleDate.Month.ToString();

        }
        protected void Calendar1_VisibleMonthChanged(object sender, MonthChangedEventArgs e)
        {
            calendarset();
            buildmonthsyears(ref ddlyears, ref ddlmonths, Calendar1.VisibleDate.Date, ctdob.Value);
        }
        protected void lbtoday_Click(object sender, EventArgs e)
        {
            Calendar1.VisibleDate = System.DateTime.Now;
            calendarset();
            buildmonthsyears(ref ddlyears, ref ddlmonths, Calendar1.VisibleDate.Date, ctdob.Value);
        }
        protected void ddlmonths_SelectedIndexChanged(object sender, EventArgs e)
        {
            Calendar1.VisibleDate = new DateTime(validToInteger(ddlyears.SelectedValue), validToInteger(ddlmonths.SelectedValue), 1);
            calendarset();
        }
        protected void ddlyears_SelectedIndexChanged(object sender, EventArgs e)
        {
            Calendar1.VisibleDate = new DateTime(validToInteger(ddlyears.SelectedValue), validToInteger(ddlmonths.SelectedValue), 1);
            calendarset();
        }

        private void buildmonthsyears(ref System.Web.UI.WebControls.DropDownList ddlyears, ref System.Web.UI.WebControls.DropDownList ddlmonths, DateTime pdate, string dob)
        {
            ddlyears.Items.Clear();
            ddlmonths.Items.Clear();
            DateTime cvd = pdate;
            if (cvd.Year == 1) // year 1 = default value
                cvd = DateTime.Now;

            // load 12 months and back and forth 10 years
            DateTime mda = DateTime.Now;
            for (int ida = 1; ida < 13; ida++)
            {
                DateTime dti = new DateTime(mda.Year, ida, 1);
                ddlmonths.Items.Add(new System.Web.UI.WebControls.ListItem(dti.ToString("MMMM"), ida.ToString()));
                if (ddlmonths.Items[ida - 1].Value == cvd.Month.ToString())
                    ddlmonths.Items[ida - 1].Selected = true;
            }

            int ddlct = 0;
            int startyear = 2015;
            int endyearadd = 5;
            if (dob == "1")
            {
                startyear = cvd.Year - 120;
                endyearadd = 1;
            }
            for (int ida = startyear; ida < (cvd.Year + endyearadd); ida++)
            {
                ddlyears.Items.Add(new System.Web.UI.WebControls.ListItem(ida.ToString(), ida.ToString()));
                if (ida == cvd.Year)
                    ddlyears.Items[ddlct].Selected = true;
                ddlct++;
            }
        }
        private int validToInteger(string pval)
        {
            int iretval = 0;
            int.TryParse(pval, out iretval);
            return iretval;
        }

        private DateTime validToDateTime(object pobj)
        {
            DateTime retval = new DateTime();
            DateTime.TryParse(pobj.ToString(), out retval);
            return retval;
        }
    }
}