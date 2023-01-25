<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DocVisitRequest.aspx.cs" Inherits="Design_IPD_DocVisitRequest" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Src="~/Design/Controls/StartDateTime.ascx" TagName="StartDate" TagPrefix="uc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Doctor Visit Request</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript" src ="../../Scripts/jquery-1.7.1.min.js"></script>
    <link rel="Stylesheet"  type="text/css" href="../../Scripts/chosen.css"/>
     <script type="text/javascript" src="../../Scripts/chosen.jquery.js"></script>
       <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" >   

        function validate() {
            if ($("#cblDoctor input[type=checkbox]:checked").length == "0") {
                $("#lblmsg").text('Please Select Doctor');
                   return false;
               }
        }

        $(function () {
            $("[id*=chkDoctor]").bind("click", function () {
                if ($(this).is(":checked")) {
                    $("[id*=cblDoctor] input").attr("checked", "checked");
                } else {
                    $("[id*=cblDoctor] input").removeAttr("checked");
                }
            });

            $("[id*=cblDoctor] input").bind("click", function () {
                if ($("[id*=cblDoctor] input:checked").length == $("[id*=cblDoctor] input").length) {
                    $("[id*=cblDoctor]").attr("checked", "checked");
                } else {
                    $("[id*=chkDoctor]").removeAttr("checked");
                }
            });
        });
    </script>
    </head>
    <body>
    <form id="form1" runat="server">
            <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
     <div class="POuter_Box_Inventory" style="text-align: center;">           
                <b>Doctor Visit Request</b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"  ClientIDMode="Static" />     
         <asp:Label ID="LbltID"     runat="server" ClientIDMode="Static" Style="display:none"> </asp:Label>
        </div>
         <asp:Panel ID="pnlPatient" runat="server">
             <div class="POuter_Box_Inventory">
                 <div class="Purchaseheader">
                    Select Criteria
                </div>
                   <table  style="width: 100%;border-collapse:collapse">
                       <tr>
                             <td  style="width: 15%;text-align:right">
                                Select Date Time :&nbsp;
                            </td>
                            <td  style="width: 85%;text-align:left"> 
                                 <%--<uc1:StartDate ID="txtDate" runat="server" />--%>                               
                                <asp:TextBox ID="txtDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" 
                                    Width="100px"  AutoPostBack="True" OnTextChanged="txtDate_TextChanged"></asp:TextBox>
                                <cc1:CalendarExtender ID="calucDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                                <asp:TextBox ID="toDate" runat="server"  Visible="false" ToolTip="Click to Select Date" TabIndex="5"
                                    Width="100px"></asp:TextBox>
                                <cc1:CalendarExtender ID="caltoDate" runat="server" TargetControlID="toDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                            </td>                          
                           </tr>
                        <tr>
                           <td style="height:10px;"></td>
                       </tr>
                     <tr>
                        <td style="width: 12%; text-align: right">Search By Name :&nbsp;</td>
                        <td style="text-align: left;">
                            <input id="txtSearch" onkeyup="SearchCheckbox(this,cblDoctor)" style="width: 300px"  /></td>
                        <td></td>
                    </tr>
                         <tr>
                           <td style="height:10px;"></td>
                       </tr>                      
                       <tr>
                           <td style="width: 12%; text-align: right; ">
                            <%--<asp:CheckBox ID="chkDoctor" runat="server" AutoPostBack="false" Text="Doctor :&nbsp;" Checked="true" CssClass="ItDoseCheckbox" />--%>
                               <asp:Label ID="lblDoc" runat="server" Text="Doctor :"></asp:Label>
                        </td>
                             <td style="width: 17%; height: 25%; ">
                                <div class="scrollankur" style="text-align: left">
                                    <asp:CheckBoxList ID="cblDoctor" CssClass="ItDoseCheckbox" Font-Size="8" runat="server" ClientIDMode="Static"
                                        RepeatDirection="Horizontal" RepeatLayout="Table" RepeatColumns="6" />
                                </div>
                        </td>
                       </tr>
                       </table>
                 </div>
               <div class="POuter_Box_Inventory">
                   <div class="content" style="text-align: center;">
                        <asp:Button ID="btnDocRequest" runat="server" CssClass="ItDoseButton" Text="Save Visit Request" OnClick="btnDoctorRequest_Click" OnClientClick="return validate()" />
                       </div>
                   </div>
             </asp:Panel>
    </div>
    </form>
</body>
</html>
