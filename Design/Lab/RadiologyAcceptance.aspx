<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    MaintainScrollPositionOnPostback="true" CodeFile="RadiologyAcceptance.aspx.cs"
    Inherits="Design_Lab_RadiologyAcceptance" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
      <style type="text/css">
        
        .blinking{
                    animation:blinkingText 1.2s infinite;
                }
                @keyframes blinkingText{
                    0%{     color: #000;    }
                    49%{    color: #000; }
                    60%{    color: transparent; }
                    99%{    color:transparent;  }
                    100%{   color: #000;    }
                }
    </style>

       <style type="text/css">
            .TextSize {
            color: Red;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
        }

        .blink-two {
            animation: blinker-two 2.6s linear infinite;
        }

        @keyframes blinker-two {
            100% {
                opacity: 0;
            }
        }
    </style>
    <link rel="Stylesheet" href="../../Scripts/fancybox/jquery.fancybox-1.3.4.css" type="text/css" />
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.fancybox-1.3.4.pack.js"></script>
    <script type="text/javascript" src="../../Scripts/fancybox/jquery.mousewheel-3.0.4.pack.js"></script>
    <script type="text/javascript">
        $(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });

            $('#ToDate').change(function () {
                ChkDate();
            });
        });


        function ChkDate() {
            $.ajax({


                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');

                    }
                }
            });

        }

        function WriteToFile(data, name) {
            try {
                var fso = new ActiveXObject("Scripting.FileSystemObject");
                var s = fso.CreateTextFile("C:\\BarCode\\" + name + ".txt", true);
                s.WriteLine(data);
                s.Close();
            }
            catch (e) { }
        }

        function doClick(buttonName, e) {
            //the purpose of this function is to allow the enter key to 
            //point to the correct button to click.
            var key;

            if (window.event)
                key = e.keyCode;
                // key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox

            if (key == 80 || key == 13) {
                //Get the button the user wants to have clicked
                var btn = document.getElementById(buttonName);

                if (btn != null) { //If we find the button click it
                    btn.click();
                    //event.keyCode = 0
                }
            }
        }
        $(document).ready(function () {
            show();
            $('#ddlPanel').chosen();

            $("#<%=btnRemove.ClientID%>").live('click', function (e) {
                e.preventDefault();
                var Reason = $("#<%=txtReasonRemove.ClientID%>").val();
                if (Reason != "") {
                    __doPostBack('ctl00$ContentPlaceHolder1$btnRemove', '');
                }
                else {
                    modelAlert('Please Enter Valid Reason..');
                }
            });
        });
        function ShowInvestigationRenovePopup() {
            $('#dvInvestigationRenovePopup').showModel();
        }

        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '0') {
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#lblIPDNoCap").show();
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '1' || $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '3') {
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $("#lblIPDNoCap").hide();
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '2') {
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#lblIPDNoCap").show();
            }
        }
        function validatespace() {
            var card = $('#<%=txtPName.ClientID %>').val();
            if (card.charAt(0) == ' ' || card.charAt(0) == '.' || card.charAt(0) == ',') {
                $('#<%=txtPName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                card.replace(card.charAt(0), "");
                return false;
            }
            else {
                // $('#<%=lblMsg.ClientID %>').text('');
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
                // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            var card = $('#<%=txtPName.ClientID %>').val();
            if (card.charAt(0) == ' ') {
                $('#<%=txtPName.ClientID %>').val('');
                $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                return false;
            }
            //List of special characters you want to restrict
            if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <script type="text/javascript">
        var selectedRow = '';



        $EnterNotifiTime = function (e, rowID) {
            e.preventDefault();
            var IPDNo = $(rowID).closest('tr').find('#lblTransactionID').text();
            var InvName = $(rowID).closest('tr').find('#lblInvName').text();
            var TestID = $(rowID).closest('tr').find('#lblTestId').text();
            var LastDate = $(rowID).closest('tr').find('#lblNotificationDate').text();
            var LastTime = $(rowID).closest('tr').find('#lblNotificationTime').text();
            getNotificationDetails({ transactionID: 'ISHHI' + IPDNo, testID: TestID }, function () {





                var divEnterNotifiTime = $('#divEnterNotifiTime');
                divEnterNotifiTime.find('#lblModelIPDNo').text(IPDNo);
                divEnterNotifiTime.find('#lblModelTestName').text(InvName);
                divEnterNotifiTime.find('#lblModelTestID').text(TestID);
                divEnterNotifiTime.find('#lblRowID').text(rowID);
                divEnterNotifiTime.find('#lblLastNotifiDate').text(LastDate);
                divEnterNotifiTime.find('#lblLastNotifiTime').text(LastTime);
                selectedRow = $(rowID).closest('tr');

                $('#divEnterNotifiTime').showModel();

            });
        }




        var getNotificationDetails = function (data, callback) {
            serverCall('RadiologyAcceptance.aspx/GetNotificationDetails', data, function (response) {
                responseData = JSON.parse(response);
                var parseHTML = $('#template_searchNotifications').parseTemplate(responseData);
                $('.notificationDetails').html(parseHTML);
                callback(responseData);
            });
        }













        var CloseNotifiTime = function () {
            $('#divEnterNotifiTime').closeModel();
        }

        $saveNotificationTime = function (TestDetail) {
            if (TestDetail.Time.trim() != '') {
                serverCall('RadiologyAcceptance.aspx/SaveNotificationTime', { TransactionID: TestDetail.TransactionID, TestID: TestDetail.TestID, Date: TestDetail.Date, Time: TestDetail.Time, remarks: TestDetail.remarks }, function (response) {
                    var result = parseInt(response);
                    if (result > 0) {
                        $('#divEnterNotifiTime').closeModel();
                        selectedRow.closest('tr').find('#imgNotification').hide();
                        selectedRow.closest('tr').find('#imgNotificationSent').show();
                        //selectedRow.closest('tr').find('td:eq(11)').find('span:first').show();
                        //selectedRow.closest('tr').find('td:eq(12)').find('span:first').show();
                        modelAlert('Notification Time Enter Successfully', function () {
                            $('#btnSearch').click();
                        });
                    }
                    else {
                        modelAlert('Some Error Occured');
                    }
                });
            }
            else
                modelAlert('Enter Notification Time');
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=grdLabSearch.ClientID %>").find("input[id$=chkTransfer]").each(function () {
                this.onclick = function () {
                    var selectedRow = $(this).closest('tr');
                    if (this.checked) {
                        selectedRow.find('[id*=ddlTransferCentre]').show();
                        selectedRow.find("input[id$=chkSampleCollect]").hide();
                    }
                    else {
                        selectedRow.find('[id*=ddlTransferCentre]').hide();
                        selectedRow.find('input[id*=chkSampleCollect]').show();
                    }
                };
            });
            $("#<%=grdLabSearch.ClientID %>").find("input[id$=chkSampleCollect]").each(function () {
                this.onclick = function () {
                    var selectedRow = $(this).closest('tr');
                    if (this.checked) {
                        selectedRow.find("input[id$=chkTransfer]").hide();
                    }
                    else {
                        selectedRow.find('input[id*=chkTransfer]').show();
                    }
                };
            });
        });



        var onRadiologySave = function (e) {
            var totalChecked = $('#grdLabSearch tbody tr').find('[name$=chkPout]:checked').length;
            if (totalChecked > 0) {
                e.preventDefault();
                var divTechnicianName = $('#divTechnicianName');
                divTechnicianName.find('input[type=text]').val('');
                divTechnicianName.showModel();
            }
        }


        var onRadiologySaveClick = function (e) {

            var divTechnicianName = $('#divTechnicianName ');
            var technicianName = $.trim(divTechnicianName.find('#txtTechnician').val());

            if (String.isNullOrEmpty(technicianName)) {
                modelAlert('Please Enter Technician Name.', function () {
                    divTechnicianName.find('#txtTechnician').focus();
                });
                return false;
            }

            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', null);

        }





    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Radiology Acceptance</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" ClientIDMode="Static"
                                RepeatDirection="Horizontal" onclick="show();">
                                <asp:ListItem Text="All" Value="0" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="OPD" Value="1"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                <asp:ListItem Text="EMG" Value="3"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department :
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIPDNo" Text="IPD No." runat="server" Style="display: none"></asp:Label>
                            </label>
                            <b id="lblIPDNoCap" class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCRNo" runat="server" CssClass="ItDoseTextinputText" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" MaxLength="20"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPName" runat="server" MaxLength="30" CssClass="ItDoseTextinputText" onkeypress="return check(event)" onkeyup="validatespace();" />
                        </div>
                        <div class="col-md-3" style="display: none;">
                            <label class="pull-left">
                                Lab No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" style="display: none;">
                            <asp:TextBox ID="txtLabNo" runat="server" MaxLength="30" CssClass="ItDoseTextinputText" onkeypress="return check(event)" onkeyup="validatespace();" />
                            <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" TargetControlID="txtLabNo" FilterType="Numbers"
                                runat="server">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Accepted
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtSample" runat="server" CssClass="ItDoseRadiobuttonlist" ClientIDMode="Static"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="SY">No</asp:ListItem>
                                <asp:ListItem Value="Y">Yes</asp:ListItem>
                                <asp:ListItem Value="R">Reject</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Room Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlRoomName" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>



                    </div>
                </div>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <div class="row textCenter">
                <asp:Button ID="btnSearch" runat="server" CssClass="save" Text="Search" ClientIDMode="Static" OnClick="btnSearch_Click" /> 
            </div>
            <div class="row" style="margin-left:508px;">
                <center>
                    <div class="col-md-25">

                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #CC99FF;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">New</b>
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #bcc184;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Called</b>
                         <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellow;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">Absent</b>
                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left">IN</b>

                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90EE90;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left;">Out</b>

                        <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: red;" class="circle"></button>
                        <b style="margin-top: 5px; margin-left: 5px; float: left;">Reject</b>

                    </div>
                </center>
            </div>
        </div>
        <asp:Panel ID="pnlHide" runat="server" Visible="false">
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Search Result
                </div>
                <div style="height:340px;overflow:auto;">
                    <asp:GridView ID="grdLabSearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" ClientIDMode="Static"
                        OnRowDataBound="grdLabSearch_RowDataBound" Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="#">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="25px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                    <%--<img alt="" src="../../Images/view.gif" onclick="$PatientDetails(event,this)" id="imgcon" />--%>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="15px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                <ItemTemplate>
                                    <img alt="" src="../../Images/view.gif" onclick="$PatientDetails(event,this)" id="imgcon" /> 
                                </ItemTemplate>
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="15px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="15px" />
                                <ItemTemplate> 
                                    <img alt="" src="../../Images/home.gif" onclick="$PatientHistory(event,this)" id="img1" title="Patient History" />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Type">
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblEntryType" ClientIDMode="Static" runat="server" Text=' <%#Eval("EntryType") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UHID">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID" ClientIDMode="Static" runat="server" Text='<%#Util.GetString(Eval("PatientID")).Replace("LSHHI","") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="50px" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" HorizontalAlign="Right" />
                                <ItemTemplate>
                                    <asp:Label ID="lblTransactionID" runat="server" ClientIDMode="Static" Text='<%#Eval("TransactionID") %>'></asp:Label>
                                    <asp:Label ID="lblLedTnx" runat="server" ClientIDMode="Static" Text='<%#Eval("LedgerTransactionNo") %>' Style="display: none"></asp:Label>
                                <asp:Label ID="lblLtdId" runat="server" ClientIDMode="Static" Text='<%#Eval("LtdId") %>' Style="display: none"></asp:Label>
                               
                                    
                                     </ItemTemplate>
                            </asp:TemplateField>
                            <%-- <asp:TemplateField HeaderText="Lab No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Font-Bold="True" Width="90px" />
                                <ItemTemplate>
                                    

                                </ItemTemplate>
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="145px" />
                                <ItemTemplate>
                                    <%#Eval("PName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                <ItemTemplate>
                                    <%#Eval("Age") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Panel Name">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="250px" />
                                <ItemTemplate>
                                    <%#Eval("Company_Name") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Department">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                <ItemTemplate>
                                    <%#Eval("ObservationName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Investigation">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblInvName" ToolTip='<%#Eval("Name") %>' runat="server" ClientIDMode="Static" Text='<%#Eval("Name") %>' style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;color:black;" class="tooltips" data-placement="top"  ></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                                <ItemTemplate>
                                    <%#Eval("InDate") + " " + Eval("Time")%>
                                    <asp:Label ID="lblResult" runat="server" Text=' <%#Eval("IsResult") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblNotification" runat="server" Text=""></asp:Label>
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgNotification" runat="server" ImageUrl="~/Images/RadiologyNotification.png" ClientIDMode="Static" OnClientClick="$EnterNotifiTime(event,this)" />
                                    <asp:ImageButton ID="imgNotificationSent" runat="server" ImageUrl="~/Images/greentick.jpg" Style="display: none" ClientIDMode="Static" OnClientClick="$EnterNotifiTime(event,this)" />
                                    <asp:Label ID="lblIsNotificationSent" runat="server" Text='<%#Eval("isnotificationsent") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblNotificationDate" ClientIDMode="Static" runat="server" Text='<%#Eval("NotificationDate") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblNotificationTime" ClientIDMode="Static" runat="server" Text='<%#Eval("NotificationTime") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblP_IN" runat="server" ClientIDMode="Static" Text='<%#Eval("P_IN") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblP_Out" runat="server" ClientIDMode="Static" Text='<%#Eval("P_Out") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblPendingcheck" runat="server" ClientIDMode="Static" Text='<%#Eval("Pendingcheck") %>' Style="display: none"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader" runat="server" Text="IN"></asp:Label>
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSampleCollect" runat="server" ClientIDMode="Static" Style="display: none" />
                                    <asp:Label ID="lblTestId" runat="server" Text='<%#Eval("Test_Id") %>' ClientIDMode="Static" Style="display: none"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader" runat="server" Text="Out"></asp:Label>
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPout" runat="server" ClientIDMode="Static" Style="display: none" />

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblheader" runat="server" Text="Consumbales"></asp:Label>
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <%--  <asp:ImageButton ID="imgcon" Visible="false" runat="server" ImageUrl="~/Images/plus_blue.png" ClientIDMode="Static" onclick="$EnterConsumbales(event,this)" />--%>
                                    <img alt="" src="../../Images/plus_blue.png" onclick="$EnterConsumbales(event,this)" id="imgcon" <%#Eval("con")%> />
                                    <asp:Label ID="lblInvestigation_Id" runat="server" ClientIDMode="Static" Text=' <%#Eval("Investigation_Id") %>'
                                        Style="display: none"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Call/ UnCall">
                                <ItemTemplate> 
                                     
                                    <asp:CheckBox ID="chkCallUncall" runat="server" CssClass="clChk" Visible='<%# Eval("IsPaymentApproved").ToString() == "1" ? true : false %>'  />
                                    <asp:Label ID="lblMessageOfApproval" runat="server" CssClass="blink-two blink TextSize" title='<%#Eval("PendingApprovalMessage") %>' Text='P'    Visible='<%# Eval("IsPaymentApproved").ToString() == "0" ? true : false %>'></asp:Label>
                                     <asp:Label ID="lblCallStatus" runat="server" Text='<%#Eval("CallStatus") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblTokenNo" runat="server" Text='<%#Eval("TokenNo") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                            </asp:TemplateField>

                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblTransferCentre" runat="server" Text="Centre Transfer"></asp:Label>
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                <ItemTemplate>
                                    <div style="display: inline-block">
                                        <div style="display: inline-block">
                                            <asp:CheckBox ID="chkTransfer" runat="server" ClientIDMode="Static" Style="display: none" />
                                        </div>
                                        <div style="display: inline-block">
                                            <asp:DropDownList ID="ddlTransferCentre" runat="server" ClientIDMode="Static" Width="130px" Style="display: none" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField Visible="false">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtPrintout" Text="0" runat="server" Width="25px"></asp:TextBox>
                                    <asp:Label ID="lblObservationType_Id" runat="server" Text=' <%#Eval("ObservationType_Id") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text=' <%#Eval("ID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIsRemoveCRDREntry" runat="server" Text=' <%#Eval("vIsRemoveCRDREntry") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblLedgerTnxID" runat="server" Text=' <%#Eval("LedgerTnxID") %>' Visible="false"></asp:Label>
                                    <cc1:FilteredTextBoxExtender ID="Return" runat="server" FilterMode="ValidChars" FilterType="Custom,Numbers"
                                        TargetControlID="txtPrintout">
                                    </cc1:FilteredTextBoxExtender>
                                </ItemTemplate>
                            </asp:TemplateField>


                            <asp:TemplateField HeaderText="Technician Name">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                <ItemTemplate>
                                    <%#Eval("technician")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Portable">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                                <ItemTemplate>
                                   <div  class='<%#Eval("Portable")%>'><%#Eval("Text")%></div>   
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="Label1" runat="server" Text="Forward"></asp:Label>
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    
                    <input id="btnForwardLabObs" type="button" value="Forward" class="ItDoseButton btnForSearch  SampleStatus demo"  onclick="Forward(this);" style="height:25px;"  />
                                    
                                    <asp:Label ID="Label6" runat="server" ClientIDMode="Static" Text='<%#Eval("Test_Id") %>' Style="display: none"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            

                        </Columns>
                    </asp:GridView>
                </div>
             
            </div>
        </asp:Panel>
          <div class="POuter_Box_Inventory"> 
              <center>
                    <asp:Button ID="btnCall" runat="server" Text="Call" Style="width: 100px;" OnClick="btnCall_Click" Visible="false"/>
                    <asp:Button ID="btnUnCall" runat="server" Text="Un-Call" Style="width: 100px;" OnClick="btnUnCall_Click" Visible="false"/>
                     <asp:Button ID="btnSave" runat="server" CssClass="save" OnClick="btnSave_Click" Text="Save" Visible="false" OnClientClick="onRadiologySave(event);" />
                     <button type="button" id="btnRemoveTest" class="save" runat="server" clientidmode="Static" onclick="ShowInvestigationRenovePopup()" Visible="false">Reject Test</button>
                  </center>
                </div>
    </div>
     
    &nbsp;<div style="display: none;">
        <asp:Button ID="btnHidden" runat="server" Text="Button" CssClass="ItDoseButton" />
    </div>
    <div id="dvInvestigationRenovePopup" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 920px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="dvInvestigationRenovePopup" aria-hidden="true">&times;</button>
                    <b class="modal-title">Test Removal Reason</b>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-1">
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Reason
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-16">
                            <asp:TextBox ID="txtReasonRemove" CssClass="requiredField" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:Button ID="btnRemove" runat="server" CssClass="ItDoseButton" Text="Reject Test" OnClick="btnRemove_Click"></asp:Button>
                        </div>
                        <div class="col-md-1">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" data-dismiss="dvInvestigationRenovePopup">Close</button>
                </div>
            </div>
        </div>
    </div>

    <div id="divEnterNotifiTime" class="modal fade ">
        <div class="modal-dialog">
            <div class="modal-content" style="width: 1024px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divEnterNotifiTime" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">Create Notification</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">IPD No   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <label id="lblModelIPDNo" class="patientinfo"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">TestName   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19">
                            <label id="lblModelTestName" class="patientinfo"></label>
                            <label id="lblModelTestID" style="display: none;"></label>
                            <label id="lblRowID" style="display: none;"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Last Date   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <label id="lblLastNotifiDate" class="patientinfo"></label>
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">Last Time   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <label id="lblLastNotifiTime" class="patientinfo"></label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Date   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <asp:TextBox ID="txtNotificationDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="ccNotifiDate" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="txtNotificationDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-5">
                            <label class="pull-left">Time   </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-7">
                            <asp:TextBox ID="txtNotificationTime" runat="server" ClientIDMode="Static"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtNotificationTime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-5">
                            <label class="pull-left">Remark</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-19" >
                               <textarea id="txtRemarks" cols="4" rows="5" style="max-height:33px;min-height:33px;"></textarea>
                        </div>
                    </div>
                </div>

                <div class="row" style="border-top: 1px solid #e5e5e5; margin-right: 0px; margin-left: 0px; padding-top: 2px;">
                    <div class="col-md-24">
                        <button type="button" class="save margin-top-on-btn" data-dismiss="divEnterNotifiTime" style="float: right;">Close</button>
                        <button type="button" class="save margin-top-on-btn" style="float: right; margin-right: 5px;" onclick="$saveNotificationTime({TransactionID:$('#lblModelIPDNo').text(),TestID:$('#lblModelTestID').text(),Date:$('#txtNotificationDate').val(),Time:$('#txtNotificationTime').val(),remarks:$('#txtRemarks').val()})">Save</button>
                    </div>
                </div>

                <div class="row" style="border-top: 1px solid #e5e5e5;margin-right: 0px; margin-left: 0px;">
                    <div class="Purchaseheader" style="margin-top:5px;">Notification History</div>
                    <div class="notificationDetails" style="max-height: 180px;min-height: 100px;overflow:auto"></div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function Forward(id) {
            //resultStatus = "Forward";

            $('#ModalPopupExtender2').show();
            $("#<%=ddltest.ClientID %> option").remove();
            //var testid = $("#Label6").html();
            var testid=( $(id).siblings('span').text());
            //alert(testid);
            var ddlTest = $("#<%=ddltest.ClientID %>");
            $.ajax({
                url: "RadiologyAcceptance.aspx/BindTestToForward",
                data: '{ testid: "' + testid + '"}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    Tdata = $.parseJSON(result.d);
                    for (i = 0; i < Tdata.length; i++) {
                        ddlTest.append($("<option></option>").val(Tdata[i]["test_id"]).html(Tdata[i]["name"]));
                    }
                    ddlTest.chosen();
                    ddlTest.trigger('chosen:updated');
                    $('#ctl00_ContentPlaceHolder1_ddltest_chosen').css("width", "200px");
                },
                error: function (xhr, status) {
                }
            });


            $("#<%=ddlcentre.ClientID %> option").remove();
                    var ddlcentre = $("#<%=ddlcentre.ClientID %>");
            $.ajax({
                url: "RadiologyAcceptance.aspx/BindCentreToForward",
                data: '{}', // parameter map 
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    Cdata = $.parseJSON(result.d);
                    for (i = 0; i < Cdata.length; i++) {
                        ddlcentre.append($("<option></option>").val(Cdata[i]["centreid"]).html(Cdata[i]["centre"]));
                    }
                    ddlcentre.chosen();
                    ddlcentre.trigger('chosen:updated');
                    $('#ctl00_ContentPlaceHolder1_ddlcentre_chosen').css("width", "200px");
                },
                error: function (xhr, status) {
                }
            });
            binddoctoforward();
            $('#ModalPopupExtender2').show();
        }

        function binddoctoforward() {
            $("#<%=ddlforward.ClientID %> option").remove();
                    var ddlforward = $("#<%=ddlforward.ClientID %>");
                    $.ajax({
                        url: "RadiologyAcceptance.aspx/BindDoctorToForward",
                        data: '{centre:"'+$('#<%=ddlcentre.ClientID%> option:selected').val() +'"}', // parameter map 
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            Fdata = $.parseJSON(result.d);
                            for (i = 0; i < Fdata.length; i++) {
                                ddlforward.append($("<option></option>").val(Fdata[i]["employeeid"]).html(Fdata[i]["Name"]));
                            }
                            ddlforward.chosen();
                            ddlforward.trigger('chosen:updated');
                            $('#ctl00_ContentPlaceHolder1_ddlforward_chosen').css("width", "200px");
                        },
                        error: function (xhr, status) {
                        }
                    });
                }
                function Forwardme() {
                    var length1 = $('#<%=ddltest.ClientID %>  option').length;
                    if ($("#<%=ddltest.ClientID %> option:selected").val() == "" || length1 == 0) {
                        //$('#msgField').html('');
                        //$('#msgField').append("Please Select Test");
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert('Please Select Test');
                        $("#<%=ddltest.ClientID %>").focus();
                        return;
                    }
                    var length2 = $('#<%=ddlcentre.ClientID %>  option').length;
                    if ($("#<%=ddlcentre.ClientID %> option:selected").val() == "" || length2 == 0) {
                        //$('#msgField').html('');
                        //$('#msgField').append("Please Select Centre");
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);
                        modelAlert('Please Select Centre');
                        $("#<%=ddlcentre.ClientID %>").focus();
                        return;
                    }

                    var length3 = $('#<%=ddlforward.ClientID %>  option').length;
                    if ($("#<%=ddlforward.ClientID %> option:selected").val() == "" || length3 == 0) {
                        //$('#msgField').html('');
                        //$('#msgField').append("Please Select Doctor to Forward");
                        //$(".alert").css('background-color', 'red');
                        //$(".alert").removeClass("in").show();
                        //$(".alert").delay(1500).addClass("in").fadeOut(1000);]
                        modelAlert('Please Select Doctor to Forward');
                        $("#<%=ddlforward.ClientID %>").focus();
                        return;
                    }


                    $.ajax({
                        url: "RadiologyAcceptance.aspx/ForwardMe",
                        data: '{testid:"' + $('#<%=ddltest.ClientID%> option:selected').val() + '" ,centre:"' + $('#<%=ddlcentre.ClientID%> option:selected').val() + '",forward:"' + $('#<%=ddlforward.ClientID%> option:selected').val() + '", MobileApproved:0,MobileEMINo:"", MobileNo: "", MobileLatitude: "", MobileLongitude: ""}', // parameter map 
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            if (result.d == "1") {
                                //  $('#msgField').html('');
                                //  $('#msgField').append("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
                                //  $(".alert").css('background-color', '#04b076');
                                //  $(".alert").removeClass("in").show();
                                //  $(".alert").delay(1500).addClass("in").fadeOut(1500);

                                modelAlert("Test Forward To " + $('#<%=ddlforward.ClientID%> option:selected').text());
                                $('#ModalPopupExtender2').hide();
                                var totalRows = PatientData.length - 1;
                                if (totalRows > currentRow) {

                                    PickRowData(currentRow + 1);

                                }
                                else {
                                    PickRowData(currentRow);
                                }

                            }
                            else {
                                //$('#msgField').html('');
                                //$('#msgField').append(result.d);
                                //$(".alert").css('background-color', 'red');
                                //$(".alert").removeClass("in").show();
                                //$(".alert").delay(1500).addClass("in").fadeOut(1500);
                                modelAlert(result.d);
                            }
                        },
                        error: function (xhr, status) {
                        }
                    });
                }

        $EnterConsumbales = function (e, rowID) {
            var PID = $(rowID).closest('tr').find('#lblPatientID').text();
            var TID = $(rowID).closest('tr').find('#lblTransactionID').text();
            var Type = $(rowID).closest('tr').find('#lblEntryType').text();
            var LabNo = $(rowID).closest('tr').find('#lblLedTnx').text();
            var Investigation_Id = $(rowID).closest('tr').find('#lblTestId').text();
            var href = "../Lab/Film.aspx?TID=ISHHI" + TID + "&PID=" + PID + "&LabType=" + Type + "&LedgerTransactionNo=" + LabNo + "&Investigation_Id=" + Investigation_Id + "";
            showuploadbox(href, 1050, 1050, '73%', '90%');
        }
        $PatientDetails = function (e, rowID) {
            var LabNo = $(rowID).closest('tr').find('#lblLedTnx').text();
            var TestID = $(rowID).closest('tr').find('#lblTestId').text();
            var href = "../Lab/PatientSampleinfoPopup.aspx?TestID=" + TestID + "&LabNo=" + LabNo + "";
            showuploadbox(href, 1050, 1050, '90%', '90%');
        }
        $PatientHistory = function (e, rowID) {
            var PID = $(rowID).closest('tr').find('#lblPatientID').text();
            //var TID = $(rowID).closest('tr').find('#lblTransactionID').text();

            //var href = "../CPOE/Investigation.aspx?PID=" + PID + "&TID=" + TID + "";
            var href = "../CPOE/Investigation.aspx?PID=" + PID;
            showuploadbox(href, 1400, 1360, '100%', '100%');
        }
        function showuploadbox(href, maxh, maxw, w, h) {
            $.fancybox({
                maxWidth: maxw,
                maxHeight: maxh,
                fitToView: false,
                width: w,
                href: href,
                height: h,
                autoSize: false,
                closeClick: false,
                openEffect: 'none',
                closeEffect: 'none',
                'type': 'iframe'
            });
        }
    </script>



    <script id="template_searchNotifications" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOldInvestigation" style="width:100%;border-collapse:collapse;">
		 

		<thead>
						   <tr  id='Header'>
								<th class='GridViewHeaderStyle'>#</th>
								<th class='GridViewHeaderStyle' style="width: 168px;">Notification Date Time</th>
								<th class='GridViewHeaderStyle'>Remark</th>
								<th class='GridViewHeaderStyle'>Entry By</th>
								<th class='GridViewHeaderStyle'>Entry DateTime</th>
                                <th class='GridViewHeaderStyle'>Reply</th>
                                <th class='GridViewHeaderStyle'>Reply By</th>
                                <th class='GridViewHeaderStyle'>Reply DateTime</th>
						   </tr>
		</thead>
		 
		<tbody>

		<#
		var dataLength=responseData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = responseData[j];
		
		  #>
						<tr>
						<td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
						<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#= objRow.notificationDate#>  <#=objRow.notificationTime#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Remarks#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.createBy#></td>
						<td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.entryDateTime#></td>  
                        <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Reply#></td>   
                        <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.ReplyBy#></td>   
                        <td  class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.ReplyDate#></td>              
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>

<div id="ModalPopupExtender2"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: 400px;height: 200px;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="ModalPopupExtender2" aria-hidden="true">&times;</button>
					<h4 class="modal-title"> Forward Test</h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                         <div class="col-md-9" >
                                             <b class="pull-left">Select Test  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddltest" runat="server" Width="200px"  CssClass="ddltest  chosen-select"></asp:DropDownList>
                    </div> 
				</div>
			 	  		<div class="row" ">
                                         <div class="col-md-9" >
                                             <b class="pull-left">Select Centre  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddlcentre" runat="server" Width="200px" onchange="binddoctoforward()" CssClass="ddlcentre  chosen-select"></asp:DropDownList>
                    </div> 
				</div>
                    	<div class="row" >
                                         <div class="col-md-9" >
                                             <b class="pull-left">Forward To  </b>
                                             <label class="pull-right">:</label>
                                         </div>
                    <div class="col-md-8"> 
                     <asp:DropDownList ID="ddlforward" runat="server" Width="200px" CssClass="ddltest  chosen-select"></asp:DropDownList>
                    </div> 
				</div>
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                       <input type="button" value="Forward" onclick="Forwardme()" class="savebutton" />
						 <button type="button"  data-dismiss="ModalPopupExtender2" aria-hidden="true" >Close</button>
				</div>
			</div>
		</div>
	</div>


        <div id="divTechnicianName"   tabindex="-1" role="dialog"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width:330px">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="divTechnicianName" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Enter Technician Name</h4>
				</div>
				<div class="modal-body">
                    <div class="row">
                        <asp:TextBox runat="server" ClientIDMode="Static"  ID="txtTechnician"></asp:TextBox>
                    </div>
				</div>
			    <div class="modal-footer">
                         <button type="button"  class="save"  onclick="onRadiologySaveClick(event)"  >Save</button>
						 <button type="button"  data-dismiss="divTechnicianName"  class="save" >Close</button>
				</div>
            </div>
			</div>
		</div>


</asp:Content>
