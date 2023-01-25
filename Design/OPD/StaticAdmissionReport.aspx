<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="StaticAdmissionReport.aspx.cs" Inherits="Design_OPD_StaticAdmissionReport" %>

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
            <b>IPD Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Report Search Criteria
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


                <div class="col-md-3" id="divward">Ward :</div>
                <div class="col-md-5" id="divwardddl">
                    <asp:DropDownList runat="server" ID="ddlward" ClientIDMode="Static">
                    </asp:DropDownList>
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

                <div class="col-md-3" id="divdiag">Diagnosis :</div>
                <div class="col-md-5" id="divdiagtext">
                    <asp:TextBox ID="txtDiagnosis" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-3">UHID :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtUhid" runat="server"></asp:TextBox>
                </div>

                <div class="col-md-3">IPD NO :</div>
                <div class="col-md-5">
                    <asp:TextBox ID="txtIpdNo" runat="server"></asp:TextBox>
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
            <div class="row">
                <div class="col-md-3">
                    Report Type :
                </div>
                <div class="col-md-5">
                    <asp:DropDownList runat="server" ID="ddlReportType" ClientIDMode="Static" onchange="hideShowFieldInPatient()">
                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                        <asp:ListItem Text="IPD Discharge List" Value="1"></asp:ListItem>
                        <asp:ListItem Text="IPD New Admission List" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Occupancy List" Value="3"></asp:ListItem>
                        <asp:ListItem Text="IPD Readmission List" Value="4"></asp:ListItem>
                        <asp:ListItem Text="Morality" Value="5"></asp:ListItem>
                        <asp:ListItem Text="In patient - PAtient Info" Value="6"></asp:ListItem>
                         <asp:ListItem Text="In Frequences For In patient" Value="7"></asp:ListItem>
                        <asp:ListItem Text="Census By ward Report (yearly)" Value="8"></asp:ListItem>
                        <asp:ListItem Text="Precedure Done By Surgeon Wise (Theatre)" Value="9"></asp:ListItem>

                        
                        
                    </asp:DropDownList>
                </div>
                <div class="col-md-3" id="divAnesthesia1">Anesthesia Name :</div>
                <div class="col-md-5" id="divAnesthesia2">
                    <asp:DropDownList runat="server" ID="ddlAnesthesiaName" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
                </div>
            <div class="row" id="div5">
                <div class="col-md-3" id="divSurgeon1">Surgeon Name :</div>
                <div class="col-md-5" id="divSurgeon2">
                    <asp:DropDownList runat="server" ID="ddlSurgeonName" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
            
            

                <div class="col-md-3" id="divProcedure1">Procedure :</div>
                <div class="col-md-5" id="divProcedure2">
                    <asp:TextBox ID="txtProcedure" runat="server"></asp:TextBox>
                </div>
                </div>


        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnReport" runat="server" Text="Report" OnClick="btnReport_Click" />
        </div>
    </div>


    <script type="text/javascript">
        $(document).ready(function () {

            $("#<%=ddlAnesthesiaName.ClientID %>").chosen();
            $("#<%=ddlSurgeonName.ClientID %>").chosen();
            $("#<%=ddlReportType.ClientID %>").chosen();
            
            hideShowFieldInPatient();
        });

        function hideShowFieldInPatient() {
            var type = $("#ddlReportType").val();

            if (type == "6") {
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").hide();
                $("#divdiag").hide();
                $("#divdiagtext").hide();

                $("#divDateCariteria").show();
                $("#divward").show();
                $("#divwardddl").show();

                
                $("#divMonthCriteria").hide();


                $("#divAnesthesia1").hide();
                $("#divAnesthesia2").hide();
                $("#divSurgeon1").hide();
                $("#divSurgeon2").hide();
                $("#divProcedure1").hide();
                $("#divProcedure2").hide();

            }
            else if (type == "7") {

                $("#divAgeDetails").show();
                $("#divDiagnosisDetails").hide();
                $("#divdiag").hide();
                $("#divdiagtext").hide();

                $("#divDateCariteria").show();
                $("#divward").show();
                $("#divwardddl").show();


                $("#divMonthCriteria").hide();


                $("#divAnesthesia1").hide();
                $("#divAnesthesia2").hide();
                $("#divSurgeon1").hide();
                $("#divSurgeon2").hide();
                $("#divProcedure1").hide();
                $("#divProcedure2").hide();

            }
            else if (type == "8") {
                $("#divMonthCriteria").show();
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").hide();
                $("#divdiag").hide();
                $("#divdiagtext").hide();
                $("#divward").hide();
                $("#divwardddl").hide();


                $("#divDateCariteria").hide();


                $("#divAnesthesia1").hide();
                $("#divAnesthesia2").hide();
                $("#divSurgeon1").hide();
                $("#divSurgeon2").hide();
                $("#divProcedure1").hide();
                $("#divProcedure2").hide();

            }
            else if (type == "9") {
                $("#divMonthCriteria").hide();
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").show();
                $("#divdiag").hide();
                $("#divdiagtext").hide(); 
                $("#divDateCariteria").show();
                $("#divward").hide();
                $("#divwardddl").hide();
                $("#divAnesthesia1").show();
                $("#divAnesthesia2").show();
                $("#divSurgeon1").show();
                $("#divSurgeon2").show();
                $("#divProcedure1").show();
                $("#divProcedure2").show();



            }
            else {
                $("#divAgeDetails").hide();
                $("#divDiagnosisDetails").show();
                $("#divdiag").show();
                $("#divdiagtext").show();

                $("#divward").show();
                $("#divwardddl").show();


                $("#divDateCariteria").show();
                $("#divMonthCriteria").hide();

                $("#divAnesthesia1").hide();
                $("#divAnesthesia2").hide();
                $("#divSurgeon1").hide();
                $("#divSurgeon2").hide();
                $("#divProcedure1").hide();
                $("#divProcedure2").hide();
            }

        }

    </script>
</asp:Content>
