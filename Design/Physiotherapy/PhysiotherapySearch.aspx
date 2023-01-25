<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PhysiotherapySearch.aspx.cs" Inherits="Design_Physiotherapy_PhysiotherapySearch" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content2" runat="server">
    <script  src="../../Scripts/jquery.blockUI.js" type="text/javascript"></script>
    <script type="text/javascript" >

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#afeeee';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPatient(tnxNo) {
            window.open('PatientReport.aspx?TID=' + tnxNo);
        }  
    </script>
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#fromDate').change(function () {
                ChkDate();

            });

            $('#ToDate').change(function () {
                ChkDate();

            });

        });

        function getDate() {

            $.ajax({

                url: "../common/CommonService.asmx/getDate",
                data: '{}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    $('#<%=grdPatient.ClientID %>').hide();
                    return;
                }
            });
        }

        function ChkDate() {

            $.ajax({

                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#fromDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#lblMsg').text('To date can not be less than from date!');
                        //$.growlUI('Notification !!!', 'To date can not be less than from date!');
                        getDate();

                    }
                    else {
                        $('#lblMsg').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }
    
    </script>
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";

        }
    </script>

        <script type = "text/javascript">
            function BlockUI(elementID) {
                var prm = Sys.WebForms.PageRequestManager.getInstance();
                prm.add_beginRequest(function () {
                    $("#" + elementID).block({ message: '<table align = "center"><tr><td>' +
     '<img src="../../Images/loadingAnim.gif"/></td></tr></table>',
                        css: {},
                        overlayCSS: { backgroundColor: '#000000', opacity: 0.6
                        }
                    });
                });
                prm.add_endRequest(function () {
                    $("#" + elementID).unblock();
                });
            }

            $(document).ready(function () {

                BlockUI("dvgv");
                $.blockUI.defaults.css = {};
            });
            
            
</script> 
    <script type="text/javascript">
        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;

            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sm" runat="server" />
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Search Patient Consultation</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" /></div>
        </div>
        <div class="POuter_Box_Inventory">
            <table cellpadding="0px" cellspacing="0px" style="width: 100%">
                <tr>
                    <td style="text-align: right">
                        UHID :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtRegNo" runat="server" Width="150px" TabIndex="1" ToolTip="Enter UHID" />
                        
                    </td>
                    <td style="text-align: right">
                        Patient Name :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtPName" runat="server" Width="150px" TabIndex="2" ToolTip="Enter Patient Name"  />
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        App. No. :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtAppNo" runat="server" Width="150px" TabIndex="3" ToolTip="Enter  App. No." />
                        <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" TargetControlID="txtAppNo"
                            ValidChars="0987654321">
                        </cc1:FilteredTextBoxExtender>
                    </td>
                    <td style="text-align: right">
                          Doctor Name :&nbsp;
                    <td>
                       <asp:DropDownList ID="ddlDoctor" runat="server" Width="154px" TabIndex="7" ToolTip="Select  Doctor Name"/>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr style="display: none;">
                    <td style="text-align: right">
                        OPD Type :&nbsp;
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlOPDType" runat="server" Width="154px"  TabIndex="4" ToolTip="Select OPD Type"/>
                    </td>
                    <td style="text-align: right">
                        Panel :&nbsp;
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlPanel" runat="server" Width="154px"  TabIndex="5" ToolTip="Select Panel" />
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right">
                        From Appointment Date :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="fromDate" runat="server" ToolTip="Select From Date" Width="150px" TabIndex="8"
                            ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server"  TargetControlID="fromDate" Format="dd-MMM-yyyy"
                            ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td style="text-align: right">
                        To Appointment Date :&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="ToDate" runat="server" ToolTip="Select To Date" ClientIDMode="Static"
                            Width="150px" TabIndex="9"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtAppointmentDate0_CalendarExtender" runat="server" TargetControlID="ToDate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
            </table>
        </div>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" TabIndex="10" Text="Search" Style="text-align: center;"
                    OnClick="btnSearch_Click"  ToolTip="Click to Search"/>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="POuter_Box_Inventory" style="text-align:center" id="dvgv">
                    <div class="Purchaseheader">
                        Search Result
                    </div>
                   
                        <asp:GridView ID="grdPatient" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                            OnRowCommand="grdPatient_RowCommand" OnRowDataBound="grdPatient_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="S.No.">
                                    <ItemTemplate>
                                        <%#Container.DataItemIndex+1 %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="UHID">
                                    <ItemTemplate>
                                        <%#Eval("MRNo")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="App. No.">
                                    <ItemTemplate>
                                        <%#Eval("AppNo")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Patient Name">
                                    <ItemTemplate>
                                        <%#Eval("PName") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Font-Bold="true" Width="175px" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Age">
                                    <ItemTemplate>
                                        <%#Eval("age") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Sex">
                                    <ItemTemplate>
                                        <%#Eval("Sex") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Appointment Date">
                                    <ItemTemplate>
                                        <%#Eval("AppointmentDate")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Visit Type">
                                    <ItemTemplate>
                                        <%#Eval("VisitType")%>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Doctor">
                                    <ItemTemplate>
                                        <%#Eval("DName") %>
                                    </ItemTemplate>
                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="175px" />
                                </asp:TemplateField>
                               
                                <asp:TemplateField HeaderText="Select">
                                    <ItemTemplate>
                                        <a target="iframePatient" href="Physiotherapy.aspx?TID=<%#Eval("TransactionID") %>&amp;LnxNo=<%#Eval("LedgerTnxNo") %>&amp;IsDone=<%#Eval("Isdone") %>&amp;PatientID=<%#Eval("PatientID") %>&amp;App_ID=<%#Eval("App_ID") %>&amp;Physio_ID=<%#Eval("Physiotherapy_ID") %>"
                                            onclick="ReseizeIframe();">
                                            <img alt="Select" src="../../Images/Post.gif" style="border: 0px solid #FFFFFF;" /></a>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                    <HeaderStyle CssClass="GridViewHeaderStyle" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                   
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grdPatient" />
                <asp:AsyncPostBackTrigger ControlID="btnSearch" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px;
        left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true">
    </iframe>
</asp:Content>
