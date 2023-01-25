<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="StatiRecordOpd.aspx.cs" Inherits="Design_OPD_StatiRecordOpd" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>OPD Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Search Criteria
            </div>
              <div class="row">
                  <div class="col-md-3">
                    Center Name :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlCenter" ClientIDMode="Static" ></asp:DropDownList>
                </div>
                <div class="col-md-3">
                    Report Type :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlReportType" ClientIDMode="Static" onchange="hideShowFieldInPatient()">
                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                        <asp:ListItem Text="OPD Census By Ward & Out Patien" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Census By Clinic Report (yearly)" Value="2"></asp:ListItem>                        
                        <asp:ListItem Text="OPD Clinic Wise" Value="4"></asp:ListItem>
                        <asp:ListItem Text="OPD Morbidity Coading Search" Value="5"></asp:ListItem>
                       
                        
                    </asp:DropDownList>
                </div>
                 
                <div class="col-md-3">Clinic :</div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlward" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>

            </div>
            <div class="row" id="divDateCariteria">
                 
                <div class="col-md-3">
                    From Date :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromDate" runat="server" ClientIDMode="Static"> </asp:TextBox>
                    <cc1:CalendarExtender ID="fromdate" TargetControlID="txtFromDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div>

                <div class="col-md-3">To Date  :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToDate" runat="server" ClientIDMode="Static"> </asp:TextBox>
                    <cc1:CalendarExtender ID="todate" TargetControlID="txtToDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>

                </div> 
            </div>

             <div class="row" id="divMonthCriteria">
                  <div class="col-md-3">
                    Month :
                </div>
                <div class="col-md-5">

                    <asp:DropDownList runat="server" ID="ddlMonth">
                    </asp:DropDownList>
                </div>

                <div class="col-md-3">Year :</div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlYear">
                    </asp:DropDownList>
                </div>

            </div>

            <div class="row" id="divDiagnosisDetails">

                 <div class="col-md-3">UHID :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtUhid" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-3">Diagnosis :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtDiagnosis" runat="server"></asp:TextBox>
                </div>

               
 

            </div>
            <div class="row" id="divAgeDetails">
                <div class="col-md-3">
                    From Age(In Year) :
                </div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtFromAge" runat="server" TextMode="Number" Text="0"></asp:TextBox>

                </div>

                <div class="col-md-3">To Age(In Year) :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtToAge" runat="server" TextMode="Number" Text="5"></asp:TextBox>

                </div>

            </div>
         


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" />
        </div>
    </div>


    <script type="text/javascript">
        $(document).ready(function () {
            hideShowFieldInPatient();
            $("#<%=ddlward.ClientID %>").chosen();

        });

        function hideShowFieldInPatient() {
            var type = $("#ddlReportType").val();

            if (type == "2") {
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").hide();
                $("#divDateCariteria").hide();
                $("#divMonthCriteria").show();

            }
            else if (type == "3" || type == "4" || type == "5") {
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").show();
                $("#divDateCariteria").show();
                $("#divMonthCriteria").hide();

            }
            else if (type == "1") {
                $("#divAgeDetails").show();
                $("#divDiagnosisDetails").hide();
                $("#divDateCariteria").show();
                $("#divMonthCriteria").hide();

            } else {
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").hide();
                $("#divDateCariteria").hide();
                $("#divMonthCriteria").hide();
            }

        }

    </script>
</asp:Content>
