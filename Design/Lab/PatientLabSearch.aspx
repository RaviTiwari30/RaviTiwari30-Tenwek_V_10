<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientLabSearch.aspx.cs" Inherits="Design_Lab_PatientLabSearch" MasterPageFile="~/DefaultHome.master" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">


        function chkAll(rowID) {
            if ($(rowID).is(':checked'))
                $(".allChecked input[type='checkbox']").attr('checked', 'checked');
            else
                $(".allChecked input[type='checkbox']").attr('checked', false);
        }
        function chkAllPrint(rowID) {
            if ($(rowID).is(':checked'))
                $(".allPrintChecked input[type='checkbox']").attr('checked', 'checked');
            else
                $(".allPrintChecked input[type='checkbox']").attr('checked', false);
        }

        function scanLabPrescription(elem) {
            var patientID = $(elem).closest("tr").find('#spnPatientID').text().trim();
            var patientName = $(elem).closest("tr").find('[id*=lblPName]').text().trim();
            var documentName = 'Lab Prescription';
            serverCall('PatientLabSearch.aspx/getLabPrescriptionSavePath', { patientID: patientID, documentName: documentName }, function (response) {
                var excutePath = "SCN:OpenForm?id=111&mrNo=" + patientID + "&patientName=" + patientName + "&documentName=" + documentName + "&savePath=" + response + "&documentID=4&weblink=http://"+window.location.host +"/his/Design/Common/ScanDocumentServices.asmx"
                window.location = excutePath;

            });
        }


    </script>
    <script type="text/javascript">
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
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>,#<%=btnWorkSheet.ClientID %>').attr('disabled', 'disabled');
                        $('#<%=grdLabSearch.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>,#<%=btnReport.ClientID %>,#<%=btnWorkSheet.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
    </script>

    <script type="text/javascript">

        $(document).ready(function () {
            blockUIOnRequest();
            $('#ddlDepartment,#ddlInvestigation,#ddlPanel').chosen({ width: '100%' });
        });


        var blockUIOnRequest = function () {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_beginRequest(function () {
                $modelBlockUI();
            });
            prm.add_endRequest(function () {
                $modelUnBlockUI();
                MarcTooltips.add(".customTooltip", "", { position: "up", align: "left", mouseover: true });
                $('#dvgv').customFixedHeader();
            });
        }

        var getLabPrescription = function (elem) {
            var patientID = $(elem).closest("tr").find('#spnPatientID').text().trim();
            serverCall('../../design/common/ScanDocumentServices.asmx/GetDocument', { patientId: patientID, documentName: 'Lab Prescription' }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.status)
                    viewLabPrescription($responseData.data);
                else
                    modelAlert('Lab Prescription Not Found');

            });
        }


        var viewLabPrescription = function (base64Image) {
            try {
                var image = new Image();
                image.src = base64Image
                var w = window.open("", "LabPriscriptionWindow", "width=600,height=600");
                w.document.write('<title>Lab Priscription</title>' + image.outerHTML);
            } catch (e) {

            }
        }


    </script>
    <script type="text/javascript">
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
        $(document).ready(function () {
            show();
        });
        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '1' || $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '3') {
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $("#<%=lblipdcln.ClientID %>").hide();

            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == '2' || $('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == '0') {
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#<%=lblipdcln.ClientID %>").show();

            }
        }
        $("#<%=rdbLabType.ClientID %> input:radio").change(function () {
            $('#<%=lblMsg.ClientID %>').text('');
            if ($('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'OPD' || $('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'ALL') {
                $('#<%=grdLabSearch.ClientID %>').hide();
            }
            if ($('#<%=rdbLabType.ClientID %> input[type=radio]:checked').val() == 'IPD') {
                $('#<%=grdLabSearch.ClientID %>').hide();
            }
        });

        $(document).ready(function () {

            $('#<%=rdbLabType.ClientID%>').change(function () {
                $('#<%=lblMsg.ClientID %>').text('');
                $('#dvgv').hide();
            });
        });
        function FirePageLevelOkButton() {
            var okButton = document.getElementById('<%=btnSearch.ClientID %>');
            if (okButton) {
                okButton.click(); // if you have ok button in page you can fire click, 
                //this will execute codebehind code
            }
        }
        function enterEvent(e) {
            if (e.keyCode == 13) {
                $("input[id=btnSearch]").click();
            }
        }
        function resizeIframe(elem) {
            $modelBlockUI();
            var iframe = document.getElementById("iframePatient");
            var row = $(elem).closest('tr');
            iframe.onload = function () {
                iframe.style.width = '100%';
                iframe.style.height = '100%';
                iframe.style.display = '';
                try {
                    var contentDocument = document.getElementById("iframePatient").contentDocument;
                    contentDocument.getElementById('lblPatientName').innerHTML = row.find('.patientName').text().trim();
                    contentDocument.getElementById('lblDoctorName').innerHTML = row.find('.doctorName').text().trim()
                    contentDocument.getElementById('lblPatientID').innerHTML = row.find('.patientID').text().trim();
                    contentDocument.getElementById('lblPanel').innerHTML = row.find('.panel').text().trim();
                    contentDocument.getElementById('lblGender').innerHTML = row.find('td').find('#spnPatientGender').text().trim();
                    contentDocument.getElementById('lblAge').innerHTML = row.find('.age').text().trim()
                    contentDocument.getElementById('lblDiagnosisNo').innerHTML = row.find('.labNo').text().trim();
                    $modelUnBlockUI();
                }
                catch (e) {
                    $modelUnBlockUI();
                }

            };
        }

        function closeIframe() {
            var iframe = document.getElementById("iframePatient");
            iframe.style.width = '0%';
            iframe.style.height = '0%';
            iframe.style.display = 'none';
            iframe.contentWindow.document.write('');
        }

    </script>
    <script type="text/javascript">
        var $DeltaTestData = null;
        $showDeltaModel = function (DeltaTestData) {
            $DeltaTestData = null;
            $('#divDeltaCheck').showModel();
            $DeltaTestData = DeltaTestData;
        }
        $DeltaCheckTabular = function () {
            window.open('../Lab/DeltacheckNew.aspx?Type=' + $DeltaTestData.type + '&Test_ID=' + $DeltaTestData.test_ID);
        }
        $DeltaCheckGraph = function () {
            window.open('../Lab/DeltacheckGraph.aspx?Type=' + $DeltaTestData.type + '&Test_ID=' + $DeltaTestData.test_ID);
        }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Patient Investigation Search</b>
            <br />
            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
                </ContentTemplate>
            </asp:UpdatePanel>
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
                        <div class="col-md-13">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal"
                                onclick="show();">
                                <asp:ListItem Text="OPD" Value="1" ></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Emergency" Value="3"></asp:ListItem>
                                <asp:ListItem Text="All" Value="0" Selected="True"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIPDNo" Text="IPD No." runat="server" Style="display: none"></asp:Label>
                            </label>
                            <b id="lblipdcln" style="display: none;" runat="server" class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCRNo" runat="server" MaxLength="10" ToolTip="Enter IPD No." AutoCompleteType="Disabled" onkeyup="javascript:enterEvent(event);"
                                TabIndex="2" Style="display: none" />
                           
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
                            <asp:TextBox ID="txtMRNo" runat="server" TabIndex="1" data-title="Enter UHID" AutoCompleteType="Disabled" onkeyup="javascript:enterEvent(event);"
                                MaxLength="20" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Barcode No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLabNo" runat="server" MaxLength="20" TabIndex="3" AutoCompleteType="Disabled" onkeyup="javascript:enterEvent(event);"
                                data-title="Enter Barcode No." />
                            <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" runat="server" TargetControlID="txtLabNo"
                                FilterType="Numbers">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Investigation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlInvestigation" runat="server" TabIndex="10" ClientIDMode="Static" ToolTip="Select Investigation"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient&nbsp;Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPName" runat="server" TabIndex="4" data-title="Enter Patient Name" AutoCompleteType="Disabled"
                                onkeypress="return check(event)" onkeyup="validatespace();javascript:enterEvent(event);" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Test Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUrgent" runat="server" TabIndex="5" ToolTip="Select Patient Test Type">
                                <asp:ListItem Selected="True" Value="2">All</asp:ListItem>
                                <asp:ListItem Value="1">Urgent</asp:ListItem>
                                <asp:ListItem Value="0">Normal</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                CPT Code
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCptcode" runat="server" MaxLength="20" TabIndex="6" AutoCompleteType="Disabled"
                                data-title="Enter CPT Code" onkeyup="javascript:enterEvent(event);" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDepartment" runat="server" TabIndex="7" ClientIDMode="Static" ToolTip="Select Department">
                            </asp:DropDownList>

                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server" TabIndex="8" ToolTip="Select Status">
                                <asp:ListItem>All</asp:ListItem>
                                <asp:ListItem>Approved</asp:ListItem>
                                <asp:ListItem>Not Approved</asp:ListItem>
                                <asp:ListItem Selected="True">Result Not Done</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlPanel" runat="server" ClientIDMode="Static" TabIndex="9" ToolTip="Select Panel">
                            </asp:DropDownList>
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
                            <asp:TextBox ID="FrmDate" runat="server" TabIndex="11" data-title="Select From Date" onchange="ChkDate();"
                                ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtFromTime" runat="server" Style="display: none"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtFrom" Mask="99:99:99" TargetControlID="txtFromTime"
                                AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtFrom" ControlExtender="mee_txtFrom"
                                ControlToValidate="txtFromTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" TabIndex="12" onchange="ChkDate();"
                                data-title="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                            <asp:TextBox ID="txtToTime" runat="server" Style="display: none"></asp:TextBox>
                            <cc1:MaskedEditExtender runat="server" ID="mee_txtTo" Mask="99:99:99" TargetControlID="txtToTime"
                                AcceptAMPM="true" AcceptNegative="None" MaskType="Time">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator runat="server" ID="mev_txtTo" ControlExtender="mee_txtTo"
                                ControlToValidate="txtToTime" InvalidValueMessage="*"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3"></div>
                        <div class="col-md-5">
                             <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click" ClientIDMode="Static"
                                OnClientClick="javascript:FirePageLevelOkButton();" TabIndex="11" ToolTip="Click To Search" />
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-8"></div>
                        <div class="col-md-2">
                           
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnReport" runat="server" CssClass="ItDoseButton" Visible="false" Text="Report" ToolTip="Click To Open Report"
                                OnClick="btnReport_Click" />
                        </div>
                        <div class="col-md-2">
                            <input id="btnPDFPrint" type="button" value="Print PDF" style="display:none" onclick="PrintPDF()" class="ItDoseButton" />
                        </div>
                        <div class="col-md-2">
                            <asp:Button ID="btnWorkSheet" runat="server" CssClass="ItDoseButton" Text="Worksheet"
                                OnClick="btnWorkSheet_Click" Visible="false" ToolTip="Click To Open Worksheet" />
                        </div>

                        <div class="col-md-8"></div>
                    </div>
                    <div class="row"></div>
                </div>
                <div class="col-md-1"></div>
            </div>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: yellowgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Mac</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: darkgray;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left;">Due Amount</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #90EE90;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Approved</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: coral;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Not Approved</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: White;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Not Done</b>
                        </div>
                        <div class="col-md-2">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Urgent</b>
                        </div>
                        <div class="col-md-3">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: Aqua;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Outsource</b>
                        </div>
                        <div class="col-md-1 circle" style="width: 40px; height: 29px; margin-left: 5px; background-color: white;">
                            <img alt="" style="margin-top: -20px;" src="../../Images/tatdelay.gif" />
                        </div>
                        <div class="col-md-2">
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Delay</b>
                        </div>
                        <div class="col-md-2">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; background-color: #3399FF;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Print</b>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="POuter_Box_Inventory" style="text-align: center; overflow:auto;max-height:315px" id="dvgv">
                    <asp:GridView ID="grdLabSearch" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%"
                        OnRowDataBound="grdLabSearch_RowDataBound" OnRowCommand="grdLabSearch_RowCommand">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                    <asp:Image runat="server" ID="imgDelay" ImageUrl="~/Images/tatdelay.gif" Visible="false" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Type">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientType" runat="server" Text='<%# Util.GetString( Eval("Type")) %>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UHID">
                                <ItemTemplate>
                                    <asp:Label ID="lblPatientID"  runat="server" Text='<%# Util.GetString( Eval("PID")) %>'></asp:Label>
                                    <span class="patientID" style="display:none"><%# Util.GetString( Eval("PID")) %></span>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false" HeaderText="Packs No.">
                                <ItemTemplate>
                                    <%# Util.GetString(Eval("Test_ID"))%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblIPDNo" runat="server" Text='<%# Util.GetString(Eval("TransactionID")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Room" Visible="false">
                                <ItemTemplate>
                                    <%# Util.GetString(Eval("room"))%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Barcode No.">
                                <ItemTemplate>
                                    <asp:Label ID="lblLedTnx" runat="server" Text='<%# Util.GetString( Eval("BarcodeNo")) %>' Visible="false"></asp:Label>
                                    <asp:Label ID="LedgerTransactionNo" CssClass="labNo" runat="server" Text='<%# Util.GetString( Eval("BarcodeNo")) %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText=" Name">
                                <ItemTemplate>
                                     <asp:Label   class="customTooltip "   data-title='<%#Eval("PName") %>'          ID="lblPName" Style="float: left;text-align: left; max-width: 116px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" runat="server" Text='<%# Eval("PName") %>'></asp:Label>
                                     <span class="patientName" style="display:none"><%#Eval("PName") %></span>
                                     <span id="spnPatientID" style="display: none"><%# Util.GetString(Eval("PID"))%></span>
                                     <span id="spnTestID" style="display: none"><%# Util.GetString(Eval("Test_ID"))%></span>
                                     <span id="spnPatientType" style="display: none"><%# Util.GetString( Eval("Type")) %></span>
                                     <a href="javascript:void(0);" data-title="View Delta Check" onclick='<%#String.Format("$showDeltaModel({{type:\"{0}\",test_ID:\"{1}\"}})",Util.GetString(Eval("Type")),Util.GetString(Eval("Test_ID")))%>' class="icon32 customTooltip icon-color icon-triangle-n" style="float: right;margin: -8px;<%# Util.GetBoolean(Eval("IsResult"))==true?"":"display:none" %>"></a>
                                     <a href="javascript:void(0);" data-title="Track Investigation" onclick="onTrackClick(this)" class="abc customTooltip icon icon-color icon-clock" style="float: right;"></a>
                                     <a href="javascript:void(0);" data-title="View Lab Prescription" onclick='getLabPrescription(this)' class="icon customTooltip icon-color icon-document" style="float: right;"></a>
                                     <a href="javascript:void(0);" data-title="Scan Lab Prescription" onclick='scanLabPrescription(this)' class="icon customTooltip icon-color icon-print" style="float: right;"></a>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="195px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age">
                                <ItemTemplate>
                                    <asp:Label ID="lblAge"  runat="server" Text='<%# Eval("Age") %>'></asp:Label>
                                    <span class="age"  style="display:none"><%# Eval("Age") %></span>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="75px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Investigation">
                                <ItemTemplate>
                                    <div  class="customTooltip Investigation"   data-title='<%#Eval("Name") %>' style="text-align: center; max-width: 180px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        <%#Eval("Name") %>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <%#Eval("InDate") + " " + Eval("Time")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="160px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Doctor">
                                <ItemTemplate>
                                    <div  class="customTooltip doctorName"   data-title='<%#Eval("Dname") %>' style="text-align: center; max-width: 105px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        <%#Eval("Dname") %>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Panel">
                                <ItemTemplate>
                                    <div class="customTooltip panel"   data-title='<%#Eval("Panel") %>' style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;">
                                        <%#Eval("Panel") %>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Select">
                                <ItemTemplate>
                                    <span style="display: none" id="spnPatientGender">
                                        <%#Eval("Gender") %>
                                    </span>
                                    <a target="iframePatient" id="selifr" href="../Lab/LabFolder.aspx?TransactionID=<%#Eval("TransactionID") %>&amp;LedgerTransactionNo=<%#Eval("LedgerTransactionNo") %>&amp;LabType=<%#Eval("Type") %>&amp;PatientID=<%#Eval("PatientID") %>&amp;Gender=<%#Eval("Gender") %>"
                                        onclick="resizeIframe(this);">
                                        <img src="../../Images/Post.gif" alt="" />
                                    </a>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Print" Visible="false" HeaderStyle-CssClass="GridViewHeaderStyle"
                                ItemStyle-CssClass="GridViewLabItemStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblResult" runat="server" Text=' <%#Eval("IsResult") %>' Visible="false" />
                                    <asp:Label ID="lblapprove" runat="server" Text=' <%#Eval("Approved") %>' Visible="false" />
                                    <asp:Label ID="lblPendingAmount" runat="server" Text=' <%#Eval("PendingAmount") %>' Visible="false" />
                                    <asp:Label ID="lblMacStatus" runat="server" Text=' <%#Eval("MacStatus") %>' Visible="false" />
                                    <asp:Label ID="lblReportType" runat="server" Text=' <%#Eval("ReportType") %>' Visible="false" />
                                    <asp:ImageButton ID="imbPrint" runat="server" Visible="false" CausesValidation="false"
                                        CommandName="Print" ImageUrl="~/Images/print.gif" CommandArgument='<%#Eval("LedgerTransactionNo") +"#"+Eval("Test_ID") + "#" + Eval("PatientID")+"#"+Eval("ReportType")%> ' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField Visible="false">
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkSelectAll" runat="server" Style="float: right; padding-right: 5px;"
                                        ClientIDMode="Static" onclick="chkAll(this)" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPrintWorksheet" Visible='<%# !Util.GetBoolean(Eval("chkWork"))%>'
                                        runat="server" Style="float: right; padding-right: 5px;" CssClass="allChecked" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="View">
                                <ItemTemplate>
                                    <img src="../../Images/view.GIF" id="imgremarks" onclick="showRemarks(this)"  title="Doctor Remark" style='<%#Eval("Remarks")%>' />
                                    <asp:Label ID="lblLedgerTnx" ClientIDMode="Static" runat="server" Text='<%# Util.GetString( Eval("LedgerTransactionNo")) %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblInvestigation_Id" ClientIDMode="Static" runat="server" Text=' <%#Eval("Investigation_ID") %>' Style="display: none" />
                                    <asp:Label ID="lblType" ClientIDMode="Static" runat="server" Text=' <%#Eval("Type") %>' Style="display: none" />
                                    <asp:Label ID="lblTestID" ClientIDMode="Static" runat="server" Text=' <%#Eval("Test_ID") %>' Style="display: none" />
                                    <asp:Label ID="lblRemarks" ClientIDMode="Static" runat="server" Text=' <%#Eval("Remarks") %>' Style="display: none" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="No of Printout" Visible="false">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <ItemTemplate>
                                    <asp:TextBox ID="txtPrintout" Text="0" runat="server" Width="25px"></asp:TextBox>
                                    <%-- <asp:Label ID="lblTransactionID" runat="server" Text=' <%#Eval("TransactionID") %>' Visible="false"></asp:Label>--%>
                                    <cc1:FilteredTextBoxExtender ID="Return" runat="server" FilterMode="ValidChars" FilterType="Custom,Numbers"
                                        TargetControlID="txtPrintout">
                                    </cc1:FilteredTextBoxExtender>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="TestType" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblUrgent" runat="server" Text='<%#Eval("IsUrgent") %>' Font-Bold="true"></asp:Label>
                                    <asp:Label ID="lblIs_Outsource" runat="server" Text='<%#Eval("IsOutsource") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IsDelay" Visible="false">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsDelay" runat="server" Text='<%# Util.GetString( Eval("IsDelay")) %>'></asp:Label>
                                    <asp:Label ID="lblIsPrint" runat="server" Text='<%# Util.GetString( Eval("isPrint")) %>'></asp:Label>

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>

                            <asp:TemplateField Visible="false"> 
                                <HeaderTemplate>
                                    <asp:CheckBox ID="chkHeaderPrintAll" runat="server" Style="float: right; padding-right: 5px;"
                                        onclick="chkAllPrint(this)" />
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPrint" Visible='<%# Util.GetBoolean(Eval("chkWork"))%>'
                                        runat="server" Style="float: right; padding-right: 5px;" CssClass="allPrintChecked" />
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>                            
                        </Columns>
                    </asp:GridView>
                </div>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="grdLabSearch" />
                <asp:AsyncPostBackTrigger ControlID="btnSearch" />

            </Triggers>
        </asp:UpdatePanel>
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 32px; left: 0px; background-color: #FFFFFF; display: none;" frameborder="0" enableviewstate="true"></iframe>
    <div id="modal_remarks" style="display: none">
        <asp:Label ID="lblPatientRemarks" runat="server" ClientIDMode="Static" Font-Bold="true"></asp:Label>
    </div>

    <div id="divDeltaCheck" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: white; width: 350px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="divDeltaCheck" aria-hidden="true">&times;</button>
                    <h4 class="modal-title">View Patient Delta Check History</h4>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-2">
                        </div>
                        <div class="col-md-10">
                            <button type="button" onclick="$DeltaCheckTabular()">Delta Check Tabular</button>
                        </div>
                        <div class="col-md-10">
                            <button type="button" onclick="$DeltaCheckGraph()">Delta Check Graph</button>
                        </div>
                        <div class="col-md-2">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                </div>
            </div>
        </div>
    </div>


    <script type="text/javascript">
        function showRemarks(rowID) {
            var data = $(rowID).closest('tr').find("#lblRemarks").text();
            if (data != "") {
                var table = '<table  width="100%" id="table1" border="3" bordercolor="#2C5A8B"   cellspacing="2" cellpadding="2">';
                table += '<tr>';
                table += '<td   colspan="1" style="cursor: move;color:black;font-weight:bold;" class="right"><span id="row">' + data + '</span></td>';
                table += '</tr>';
                table += '</table>';
                $('#modal_remarks').html(table);
                $("#modal_remarks").dialog("open");
            }
            else {
                $("#lblMsg").text('No Remarks Found');
            }
        }
        $(function () {
            $("#modal_remarks").dialog({
                width: 600,
                autoOpen: false,
                title: "Remarks",
                show: {
                    effect: "blind",
                    duration: 1000
                },
                hide: {
                    effect: "explode",
                    duration: 1000
                }
            });

        });
    </script>
    <script type="text/javascript">
        function PrintPDF() {
            var TestID = "";
            $("#<%=grdLabSearch.ClientID%> tr").each(function () {
                if (!this.rowIndex)
                    return;
                if ($(this).closest("tr").find('input[id*="chkPrint"]').is(':checked')) {

                    if (TestID == "")
                        TestID = $.trim($(this).closest("tr").find('span[id*="lblTestID"]').text());
                    else
                        TestID = TestID + "," + $.trim($(this).closest("tr").find('span[id*="lblTestID"]').text());
                }



            });
            if (TestID != "") {

                window.open('../../Design/Lab/printLabReport_pdf.aspx?TestID=' + TestID + '&LabType=' + $("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() + '&LabreportType=<%=Util.GetString(Session["roleid"])%>');
            }
        }

    </script>
    <script type="text/javascript">
        var onTrackClick = function (elem) {
            var tr = $(elem).closest('tr');
            var testID = $.trim($(tr).find('span[id*="spnTestID"]').text());
            var patientType = $.trim($(tr).find('span[id*="spnPatientType"]').text());
            var nextTr = $(tr).next()[0];
            if (!String.isNullOrEmpty(nextTr) && nextTr.id == 'trackTr')
                $(nextTr).remove();
            else {
                getTrackInformation(testID, patientType, function (response) {
                    var investigationOn = 'Collection On ' + response.InDate + '</br>' + response.InTime;
                    var current = false;

                    var sampleOn = '~Receive On ';
                    if (!String.isNullOrEmpty(response.SampleDate))
                        sampleOn = 'Receive On ' + response.SampleDate + '</br>' + response.SampleTime;
                    else {
                        if (!current) {
                            sampleOn = '@Receive On ( Current )';
                            current = true;
                        }
                    }

                    var resultEntryOn = '~Result Entry On ';
                    if (!String.isNullOrEmpty(response.ResultDate))
                        resultEntryOn = 'Result Entry On ' + response.ResultDate + '</br>' + response.ResultTime;
                    else {

                        if (!current) {
                            resultEntryOn = '@Result Entry On ( Current )';
                            current = true;
                        }
                    }

                    var resultApprovedOn = '~Result Approved On ';
                    if (!String.isNullOrEmpty(response.ApprovedDate))
                        resultApprovedOn = 'Result Approved On ' + response.ApprovedDate + '</br>' + response.ApprovedTime;
                    else {

                        if (!current) {
                            resultApprovedOn = '@Result Approved On ( Current )';
                            current = true;
                        }
                    }


                    var resultDispatchOn = '~Report Dispatch On ';
                    if (!String.isNullOrEmpty(response.DisPatchDate))
                        resultDispatchOn = 'Report Dispatch On ' + response.DisPatchDate + '</br>' + response.DisPatchTime;

                    else {
                        if (!current) {
                            resultDispatchOn = '@Report Dispatch On  ( Current )';
                            current = true;
                        }

                    }

                    var newtr = $('<tr id="trackTr"><td colspan="17"> <div id="steps"></div></td></tr>').insertAfter(tr);
                    var steps = $(newtr).find('td').find('#steps');
                    $(steps).progressbar({
                        steps: [investigationOn, sampleOn, resultEntryOn, resultApprovedOn, resultDispatchOn]
                    });
                });
            }
        }


        var getTrackInformation = function (testID, patientType, callback) {
            serverCall('PatientLabSearch.aspx/TrackTest', { testID: testID, patientType: patientType }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.length > 0)
                    callback(responseData[0]);
            });
        }

    </script>
</asp:Content>
