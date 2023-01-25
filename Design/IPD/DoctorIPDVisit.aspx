<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DoctorIPDVisit.aspx.cs" Inherits="Design_IPD_DoctorIPDVisit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <script type="text/javascript">

        $(function () {
            shortcut.add('Alt+S', function () {
                var btnSave = $('#btnSave');
                if (btnSave.length > 0) {
                    if (!btnSave.is(":disabled") && btnSave.is(":visible")) {
                        onSave(btnSave[0]);
                     //   $saveLabPrescription(btnSave[0]);
                    }
                }
            }, addShortCutOptions);
            $('#ddlDoctor,#ddlVisitType').chosen();
        });
        var getConsultationRate = function () {

            var isAlreadySelected = 0;
            var visitDate = $.trim($('#txtVisitDate').val());
            $('#divSelectedVisits table tbody tr').each(function () {
                var details = JSON.parse($(this).find('#tdData').text());
                if (visitDate == details.visitDate)
                    isAlreadySelected += 1;
            });


            if (isAlreadySelected > 0) {
                modelAlert('Already Visit Added On this Date.')
                return false;
            }


            var data = {
                referencecode: $.trim($('#lblReferenceCode').text()),
                doctorID: $.trim($('#ddlDoctor').val()),
                doctorName: $.trim($('#ddlDoctor option:selected').text()),
                patientID: $.trim($('#lblPatientID').text()),
                transactionID: $.trim($('#lblTransactionNo').text()),
                panelID: $.trim($('#lblPanelID').text()),
                patientType: $.trim($('#lblPatientType').text()),
                room_ID: $.trim($('#lblRoomID').text()),
                roomTypeID: $.trim($('#lblCaseTypeID').text()),
                subCategoryID: $.trim($('#ddlVisitType').val()),
                visitType: $.trim($('#ddlVisitType option:selected').text()),
                visitDate: $.trim($('#txtVisitDate').val()),
            }
            serverCall('DoctorIPDVisit.aspx/GetConsultationRate', data, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    data.rateListID = responseData.data[0].rateListID;
                    data.itemcode = responseData.data[0].itemcode;
                    data.rate = Number(responseData.data[0].Rate);
                    data.scaleOfCost = Number(responseData.data[0].ScaleOfCost);
                    data.rateDetails = responseData.data;
                    data.remarks = $.trim($('#txtRemarks').val());
                    addVisitRow(data);
                }
                else {
                    modelAlert(responseData.message);
                }
            });

        }

        var addVisitRow = function (data) {


           

            var _divSelectedVisitsTableBody = $('#divSelectedVisits table tbody');
            var rate = Number(data.rate);
            var scaleOfCost = Number(data.rateDetails[0].ScaleOfCost);
            var isRateZero = false;
            if (rate <= 0)
                isRateZero = true;
            else {
                data.rate = data.rate;
            }


            var row = '<tr>';
            row += '<td class="GridViewLabItemStyle">' + (_divSelectedVisitsTableBody.find('tr').length + 1) + '</td>';
            row += '<td class="GridViewLabItemStyle">' + data.visitDate + '</td>';
            row += '<td class="GridViewLabItemStyle">' + data.doctorName + '</td>';
            row += '<td class="GridViewLabItemStyle">' + data.visitType + '</td>';
            row += '<td class="GridViewLabItemStyle" style="display:none" id="tdData" >' + JSON.stringify(data) + '</td>';
            row += '<td class="GridViewLabItemStyle" id="tdScaleofCost" style="display:none" >' + data.scaleOfCost + '</td>';
            row += '<td class="GridViewLabItemStyle"><input type="text" id="txtRate" class="ItDoseTextinputNum" value="' + data.rate + '" onlynumber="10" decimalplace="4"   onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" ' + (!isRateZero ? 'disabled' : '') + '  /> </td>';
            row += '<td class="GridViewLabItemStyle" id="tdRemarks" style="width:200px;" >' + data.remarks + '</td>';
            row += '<td class="GridViewLabItemStyle"><img style="cursor:pointer" class="" alt="" src="../../Images/Delete.gif" onclick="removeItems(this)"></td>';

            _divSelectedVisitsTableBody.append(row);

        }


        var removeItems = function (el) {
            $(el).closest('tr').remove();
        }

        var getVisitDetails = function (callback) {

            var selectedRow = $('#tableSelectedVisits tbody tr').length;

            if (selectedRow < 1) {
                modelAlert('Please add Shift First.', function () {});
                return false;
            }

            var data = 'VisitDate,SubcategoryID,ItemID,Rate,rateListID,itemcode,itemName,doctorID,scaleOfCost,remarks';
            $('#tableSelectedVisits tbody tr').each(function () {
                var details = JSON.parse($(this).find('#tdData').text());
                var rate = precise_round(($(this).find('#txtRate').val()) * ($(this).find('#tdScaleofCost').text()), 4);
                var remarks = $.trim($(this).find('#tdRemarks').text());
                data += '_' + details.visitDate + ',' + details.subCategoryID + ',' + details.rateDetails[0].ItemID + ',' + rate + ',' + details.rateListID + ',' + details.itemcode + ',' + details.doctorName + ',' + details.doctorID + ',' + details.scaleOfCost + ',' + remarks
            });
            console.log(data);
            var visitDetails = {
                Data: data,
                PatientID: $.trim($('#lblPatientID').text()),
                TransactionID: $.trim($('#lblTransactionNo').text()),
                userID: $.trim($('#lbluserID').text()),
                PanelID: $.trim($('#lblPanelID').text()),
                ItemName: '',
                DoctorID: '',
                IPDCaseType_ID: $.trim($('#lblCaseTypeID').text()),
                PatientType: $.trim($('#lblPatientType').text()),
                Room_ID: $.trim($('#lblRoomID').text())
            }
            callback(visitDetails);
        }



        var onSave = function (btnSave) {
            getVisitDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('../Doctor/Services/IPDVisitService.asmx/SaveIPDVisit', data, function (response) {
                    $(btnSave).removeAttr('disabled').val('Save');
                    var responseData = Number(response);
                    if (responseData == 1) {
                        modelAlert('Record Save Successfully', function () {
                            window.location.reload();
                        });

                    }
                    else if (responseData == 2) {
                        modelAlert('Rate is Not Set  Under this Panel & RoomType. Please contact EDP to Set Rate');
                    }
                    else {
                        modelAlert('Record Not Saved');
                    }
                });
            });
        }


    </script>


    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager runat="server" ID="scrScriptmanager"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <b>Doctor Charges</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Doctor Name  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlDoctor"></asp:DropDownList>
                    </div>

                    <div class="col-md-3">
                        <label class="pull-left">Visit   </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlVisitType"></asp:DropDownList>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Visit Date </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox runat="server" ID="txtVisitDate" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                        <cc1:CalendarExtender ID="calendarVisitOn" TargetControlID="txtVisitDate" Format="dd-MMM-yyyy" runat="server"></cc1:CalendarExtender>
                    </div>

                </div>

                 <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Remarks  </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-21">
                         <asp:TextBox runat="server" ID="txtRemarks" MaxLength="200" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                        
                    </div>
                </div>
            </div>


            <div class="POuter_Box_Inventory textCenter">
                <input type="button" value="Add Visit" onclick="getConsultationRate(this)" class=" save margin-top-on-btn" />
            </div>

            <div id="divSelectedVisits" class="POuter_Box_Inventory textCenter">
                <table id="tableSelectedVisits" cellspacing="0" style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr>
                            <th class="GridViewHeaderStyle">#</th>
                            <th class="GridViewHeaderStyle">Date</th>
                            <th class="GridViewHeaderStyle">Doctor Name</th>
                            <th class="GridViewHeaderStyle">Visit Type</th>
                             <th class="GridViewHeaderStyle" style =" display:none">Scale Of Cost</th>
                            <th class="GridViewHeaderStyle" style="width: 87px;">Rate</th>
                            <th class="GridViewHeaderStyle" style="width: 87px;">Remarks</th>
                            <th class="GridViewHeaderStyle"></th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>

            </div>



            <div class="POuter_Box_Inventory textCenter">

                <input type="button" value="Save" class="save margin-top-on-btn" onclick="onSave(this)" id="btnSave" />

                <asp:Label ID="lblTransactionNo" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblCaseTypeID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblReferenceCode" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblPanelID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblPatientID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lbluserID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblPatientType" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblRoomID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>

            </div>


            <div class="POuter_Box_Inventory textCenter">
                <asp:GridView runat="server" ID="grdPatientVisitDetails" CssClass="GridViewStyle" Width="100%" AutoGenerateColumns="False">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Visit Date">
                            <ItemTemplate>
                                <%#Eval("VisitDate") %>
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

                        <asp:TemplateField HeaderText="Doctor Name">
                            <ItemTemplate>
                                <%#Eval("DoctorName") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Amount">
                            <ItemTemplate>
                                <%#Eval("Amount") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Remarks">
                            <ItemTemplate>
                                <%#Eval("Remarks") %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewLabItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>


            </div>

        </div>

    </form>
</body>
</html>
