﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Votations.NSurvey.WebAdmin.Code;

namespace Votations.NSurvey.WebAdmin
{
    public partial class ErrorTestPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Submit_Click(object sender, EventArgs e)
        {
            string arg = ((Button)sender).CommandArgument;

            switch (arg)
            {
                case "1":
                    {
                        // Exception handled on the Generic Error Page
                        throw new InvalidOperationException("Button 1 Invalid Operation was clicked");
                        break;
                    }
                case "2":
                    {
                        // Exception handled on the current page
                        throw new ArgumentOutOfRangeException("Button 2 Argument Out of Rangewas clicked");
                        break;
                    }
                case "3":
                    {
                        // Exception handled by Application_Error
                        throw new Exception("Button 3 Generic Exception was clicked");
                        break;
                    }
                case "4":
                    {
                        // Exception handled on the Http 404 Error Page
                        Response.Redirect("NonexistentPage.aspx");
                        break;
                    }
                case "5":
                    {
                        // Exception handled on the Http Error Page
                        Response.Redirect("NonexistentPage-NoCatch.aspx");
                        break;
                    }
                case "6":
                    {
                        // Exception handled on the Generic Http Error Page
                        Response.Redirect("NonexistentPage-NoCatch.aspx/" + new string('x', 500));
                        break;
                    }
                case "7":
                    {
                        //throw new HttpException(403, "HTTP 403 Test Exception");

                        Response.Clear();
                        Response.StatusCode = 403;
                        Response.TrySkipIisCustomErrors = true;
                        Response.End();

                        break;
                    }
            }
        }

        //private void Page_Error(object sender, EventArgs e)
        //{
        //    // Get last error from the server
        //    Exception exc = Server.GetLastError();

        //    // Handle exceptions generated by Button 1
        //    if (exc is InvalidOperationException)
        //    {
        //        // Pass the error on to the Generic Error page
        //        Server.Transfer("HttpErrorPage.aspx", true);
        //    }

        //    // Handle exceptions generated by Button 2
        //    else if (exc is ArgumentOutOfRangeException)
        //    {
        //        // Give the user some information, but
        //        // stay on the default page
        //        Response.Write("<h2>Default Page Error</h2>\n");
        //        Response.Write("<p>Provide as much information here as is " +
        //          "appropriate to show to the client.</p>\n");
        //        Response.Write("Return to the <a href='Default.aspx'>" +
        //            "Default Page</a>\n");

        //        // Log the exception and notify system operators
        //        ExceptionUtility.LogException(exc, "ErrorTestPage");
        //        //ExceptionUtility.NotifySystemOps(exc);

        //        // Clear the error from the server
        //        Server.ClearError();
        //    }
        //    else
        //    {
        //        // Pass the error on to the default global handler
        //        //Server.Transfer("HttpErrorPage.aspx");
                
        //    }
        //}

    }
}