<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="News_Bulletin.aspx.cs" Inherits="Design_EDP_News_Bulletin" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>


<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        #ctl00_ContentPlaceHolder1_txtSearch {
            margin: 5px;
        }
    </style>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script type="text/javascript">
      
    </script>


    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />

    <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
    </cc1:ToolkitScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Send Circular</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <label id="lblCurrentId" style="display: none"></label>
                <div class="col-md-3">Subject :</div>
                <div class="col-md-21">
                    <asp:TextBox ID="txtsub" runat="server" ClientIDMode="Static" Width="100%" CssClass="required" MaxLength="50" AutoCompleteType="Disabled" data-title="Enter Circular Subject"></asp:TextBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    Description :
                </div>
                <div class="col-md-21">

                    <CKEditor:CKEditorControl ID="txtmsg" BasePath="~/ckeditor" runat="server" CssClass="required" EnterMode="BR" ClientIDMode="Static"></CKEditor:CKEditorControl>

                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    Date:
                </div>

                <div class="col-md-4">
                    <asp:TextBox ID="txtNewsDate" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                    <cc1:CalendarExtender ID="calfrom" TargetControlID="txtNewsDate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>

                <div class="col-md-2">
                    TIME
                </div>

                <div class="col-md-3">
                    <input type="text" id="txtStartTime" class="ItDoseTextinputText txtTime required" style="z-index: 10000001" />

                </div>
                 <div class="col-md-3">
                  Expiry  Date:
                </div>

                <div class="col-md-4">
                    <asp:TextBox ID="txtExpiryDate" runat="server" ClientIDMode="Static" TabIndex="4"></asp:TextBox>
                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtExpiryDate" Format="dd-MMM-yyyy"
                        Animated="true" runat="server">
                    </cc1:CalendarExtender>
                </div>

                <div class="col-md-2">
                  Expiry  Time
                </div>

                <div class="col-md-3">
                    <input type="text" id="txtExpiryTime" class="ItDoseTextinputText txtTime required" style="z-index: 10000001" />

                </div>
            </div>

            <div class="row">
                <div class="col-md-3">
                    Attachment:
                </div>
                <div class="col-md-12" style="text-align: left;">
                    <input id="spnIsCapTure" type="text" style="display: none" value="0" />
                    <img src="../../Images/NewImages/DischargePatient.png" id="imgAttachment" style="height: 100px; border: 1px solid green; display: none" />
                    <input type="file" id="flAttachment" />
                </div>
                 <div class="col-md-5">
                    <asp:RadioButtonList ID="rdbActive" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Value="1" Selected="True"  >Active</asp:ListItem>
                    <asp:ListItem Value="0">DeActive</asp:ListItem>
                    </asp:RadioButtonList>
                    </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">

                <div class="col-md-24">
                    <input type="button" id="btnsave" value="Save" onclick="Save()" />
                    <input type="button" id="btnEdit" value="Update" onclick="Update()" style="display: none" />
                    <input type="button" id="btnClear" value="Clear" onclick="btnhideShow(0)" style="display: none" />
                </div>
            </div>
        </div>


        <div class="POuter_Box_Inventory" style="text-align: center;">

            <div class="row ">
                <div class="col-md-24" style="text-align: center; font-weight: bolder">Latest News</div>
                <div class="col-md-24" id="divList" style="max-height: 400px; overflow-x: auto">
                    <table class="FixedHeader" id="tblatesNews" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SN.</th>

                                <th class="GridViewHeaderStyle">Subject</th>

                                <th class="GridViewHeaderStyle">News Date</th>

                                <th class="GridViewHeaderStyle">News Time</th>
                                <th class="GridViewHeaderStyle">Expiry Date</th>

                                <th class="GridViewHeaderStyle">Expiry Time</th>

                                <th class="GridViewHeaderStyle">Entry Date</th>

                                <th class="GridViewHeaderStyle">Attachment</th>

                                <th class="GridViewHeaderStyle" style="width: 50px;">View</th>

                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>

        </div>


    </div>


    <script type="text/javascript">
        function readFile() {

            if (this.files && this.files[0]) {

                var FR = new FileReader();

                FR.addEventListener("load", function (e) {
                    document.getElementById("imgAttachment").src = e.target.result;
                    $("#spnIsCapTure").val(1);
                    $("#imgAttachment").show();
                });

                FR.readAsDataURL(this.files[0]);
            }

        }

        document.getElementById("flAttachment").addEventListener("change", readFile);
    </script>

    <script type="text/javascript">


        $(document).ready(function () {
            $('#txtStartTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });
            $('#txtExpiryTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 10,
                minTime: '00:01',
                maxTime: '11:59pm',
                defaultTime: new Date(),
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });
            SearchData();
            btnhideShow(0);
        });
        function btnhideShow(type) {
            if (type == 0) {
                $("#lblCurrentId").text("");
                $("#btnsave").show();
                $("#imgAttachment").hide();
                $("#btnClear").hide();
                $("#btnEdit").hide();
                clear();
            } else {
                $("#btnsave").hide();

                $("#btnEdit").show();
                $("#btnClear").show();
            }
        }

        function EditData(rowid) {

            var CurrentId = $(rowid).closest('tr').find("#lblId").text();
            var Discription = $(rowid).closest('tr').find("#lblDiscription").text();
            var Subject = $(rowid).closest('tr').find("#lblsubject").text();
            var Date = $(rowid).closest('tr').find("#lblNewsDates").text();
            var NewsTime = $(rowid).closest('tr').find("#lblNewsTime").text();

            var ExDate = $(rowid).closest('tr').find("#lblNewsExDates").text();
            var ExNewsTime = $(rowid).closest('tr').find("#lblNewsExTimes").text();

            var Attachment = $(rowid).closest('tr').find("#tdimgAttachment").prop('src');
             
            var IsCapture = $(rowid).closest('tr').find("#lblIsCapture").text();
            var IsActive = $(rowid).closest('tr').find("#lblIsActive").text();



            $("#lblCurrentId").text(CurrentId);
            $('#txtsub').val(Subject);
            $('#txtNewsDate').val(Date);
            CKEDITOR.instances['txtmsg'].setData(Discription);

            $('#txtStartTime').val(NewsTime);
            $('#txtExpiryDate').val(ExDate);
             $('#txtExpiryTime').val(ExNewsTime);
            $('#imgAttachment').attr('src', Attachment);
            $('#spnIsCapTure').val(IsCapture);
            $('#<%=rdbActive.ClientID %>').find("input[value='" + IsActive + "']").prop("checked", true);


              $("#imgAttachment").show();
            btnhideShow(1);
        }


        function DeactivateData(rowid) {

            var CurrentId = $(rowid).closest('tr').find("#lblId").text();
            modelConfirmation('Are you sure ?', 'Do You Want to Deactivate this News Bulletin', 'Yes', 'No', function (status) {
                if (status == true) {
                    serverCall('News_Bulletin.aspx/DeactivateNewsBulliten', { Id: CurrentId }, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status) {
                                SearchData();
                            }
                        });
                    });

                } else {

                    return false;
                }


            });


        }



        function clear() {
            $('#txtsub').val("");
            CKEDITOR.instances['txtmsg'].setData("");
            $('#imgAttachment').attr('src', "");
            $('#spnIsCapTure').val("0");
            $('#txtStartTime').val();

            $('#<%=rdbActive.ClientID %>').find("input[value='1']").prop("checked", true);
        }

        var Save = function () {

            var data = {
                Subject: $('#txtsub').val(),
                Description: CKEDITOR.instances['txtmsg'].getData(),
                Date: $('#txtNewsDate').val(),
                Time: $('#txtStartTime').val(),
                Attachment: $('#imgAttachment').prop('src'),
                isCapTure: $('#spnIsCapTure').val(),
                ExpiryDate: $('#txtExpiryDate').val(),
                ExpiryTime: $('#txtExpiryTime').val(),
                IsActive: $('#<%=rdbActive.ClientID %> input:checked').val()
            }
            if (data.Subject == "" || data.Subject == undefined) {
                modelAlert(" Enter Subject Of News Bulliten.");
                return false;
            }
            if (data.isCapTure == 0) {
                data.Attachment = "";
            }

            serverCall('News_Bulletin.aspx/SaveNewsBulliten', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        SearchData();
                        btnhideShow(0);
                    }
                });
            });
        }



        function SearchData() {


            serverCall('News_Bulletin.aspx/GetDataToFill', {}, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    var count = 0;
                    $('#tblatesNews tbody').empty();
                    $.each(data, function (i, item) {

                        var rdb = '';
                        rdb += '<tr>';
                        rdb += '<td class="GridViewItemStyle">' + ++count + '</td>';
                        rdb += '<td class="GridViewItemStyle">' + item.Subject + '</td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblNewsDates">' + item.NewsDates + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblNewsTime">' + item.NewsTimes + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblNewsExDates">' + item.NewsExDates + '</lable></td>';
                        rdb += '<td class="GridViewItemStyle"> <lable id="lblNewsExTimes">' + item.NewsExTimes + '</lable></td>';

                        rdb += '<td class="GridViewItemStyle"> <lable>' + item.EntryDate + '</lable></td>';


                        rdb += '<td class="GridViewItemStyle">   <img onclick=OpenImage("' + item.Attachment + '") src=' + item.Attachment + ' id="tdimgAttachment" style="cursor:pointer;height: 100px; border: 1px solid green" />  </td>';

                        rdb += '<td class="GridViewItemStyle" ><input style="float:right" type="button" value="Edit" onclick="EditData(this)"/></td>';




                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblDiscription">' + item.Description + '</lable> </td>';


                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblIsCapture">' + item.IsAcpture + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblIsActive">' + item.IsActive + '</lable> </td>';



                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblId">' + item.Id + '</lable> </td>';
                        rdb += '<td class="GridViewItemStyle"  style="display:none"> <lable id="lblsubject">' + item.Subject + '</lable> </td>';



                        rdb += '</tr> ';

                        $('#tblatesNews tbody').append(rdb);
                    });


                }

            });
        }




        var Update = function () {

            var data = {
                Subject: $('#txtsub').val(),
                Description: CKEDITOR.instances['txtmsg'].getData(),
                Id: $("#lblCurrentId").text(),
                NewsDate: $('#txtNewsDate').val(),
                Time: $('#txtStartTime').val(), 
                Attachment: $('#imgAttachment').prop('src'),
                isCapTure: $('#spnIsCapTure').val(),
                ExpiryDate: $('#txtExpiryDate').val(),
                ExpiryTime: $('#txtExpiryTime').val(),
                IsActive: $('#<%=rdbActive.ClientID %> input:checked').val()
            }

            if (data.Id == "" || data.Id == undefined) {
                modelAlert("Error Occured ! Please Refresh Page and Try Again .");
                return false;
            }

            if (data.Subject == "" || data.Subject == undefined) {
                modelAlert(" Enter Subject Of News Bulliten.");
                return false;
            }

            if (data.isCapTure == 0) {
                data.Attachment = "";
            }


            serverCall('News_Bulletin.aspx/UpdateNewsBulliten', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status) {
                        btnhideShow(0);
                        window.location.reload();
                    }
                });
            });
        }


        function OpenImage(src) {
            var image = new Image();
            image.src = src;

            var w = window.open("");
            w.document.write(image.outerHTML);
        }
    </script>


    <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
</asp:Content>
