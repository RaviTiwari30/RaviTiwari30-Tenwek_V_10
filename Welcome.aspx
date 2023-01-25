<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Welcome.aspx.cs" Inherits="Welcome" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        #dashboard_box_inventory {
            margin: 40px 1px 1px 1px;
            display: inline-block;
            width: 1340px;
            height:600px;
           /*background-image :url(Images/welcome.png);*/
            background-repeat:no-repeat;
            background-position: center;
            background-attachment: fixed;
        }
        .well {
            min-height: 20px;
            padding: 19px;
            margin-bottom: 20px;
            background-color: #f5f5f5;
            border: 1px solid #eee;
            border: 1px solid rgba(0, 0, 0, 0.05);
            -webkit-border-radius: 4px;
            -moz-border-radius: 4px;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
            -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.05);
        }

        .row-fluid .span3 {
            width: 23.404255317%;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            HideShow(0);
            SearchData();


            if ('<%=Request.QueryString["IsAuthorize"] != null%>') {
                var IsAuthorize = '<%=Request.QueryString["IsAuthorize"]%>';
                if (IsAuthorize == 1)
                    modelAlert('You are not authroized to view this page', function () {
                      //  ShowBatchButton();
                        $('#imgShowMenu').click();
                    });
            }
            else {
                //ShowBatchButton();
                $('#imgShowMenu').click();
            }
            //ShowBatchButton();
            $('#imgShowMenu').click();
            

        });
        function CheckConfirm() {
            modelConfirmation('Confirmation!!', 'Are you sure want to closed batch', 'Yes', 'No', function (response) {
                if (response) {
                    // if (confirm('Are you sure want to closed batch!.')) {
                    var EmployeeId = $('[id$=lblEmpId]').text();
                    $.ajax({
                        url: "Welcome.aspx/CloseBatchNumber",
                        data: '{EmployeeId:"' + EmployeeId + '"}',
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            var Room = jQuery.parseJSON(result.d);
                            if (Room == true) {
                                ShowBatchButton();
                            }
                        },
                        error: function (xhr, status) {
                        }
                    });
                }
                else
                    return false;
            });
        }
        function ShowBatchButton() {
            var EmployeeId = $('[id$=lblEmpId]').text();
            $.ajax({
                url: "Welcome.aspx/ShowCloseBatchButton",
                data: '{EmployeeId:"' + EmployeeId + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    var Status = jQuery.parseJSON(result.d);
                    if (Status != '' && Status != null) {
                        if (Status[0].BatchNumber != '' && Status[0].BatchNumber != null) {
                            $('[id$=divBatchNumber]').text('Batch No.- ' + Status[0].BatchNumber);
                        }
                        if (Status[0].STATUS == "1") {
                            $('[id$=btnclosebatch]').css('display', 'none');
                            $('[id$=divBatchNumber]').css('display', 'none');
                        }
                        else {
                            $('[id$=btnclosebatch]').css('display', 'block');
                            $('[id$=divBatchNumber]').css('display', 'block');
                        }
                    }
                    else {
                        $('[id$=btnclosebatch]').css('display', 'none');
                        $('[id$=divBatchNumber]').css('display', 'none');
                    }
                },

                error: function (xhr, status) {
                }
            });
        }
    </script>

    <div id="dashboard_box_inventory">

        <cc1:ToolkitScriptManager ID="ScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <asp:Label ID="lblEmpId" runat="server" Style="display: none;"></asp:Label>
        <div class="row">
            <div class="row">
                <div class="col-md-24">
                    <div style="padding: 5px; height: 35px; color: red" class="well span3 top-block">
                        <span style="margin-top: -4px;" class="icon32 icon-color icon-rssfeed pull-left"></span>
                        <marquee behavior="scroll" direction="left" style="width: 1250px" onmouseover="this.stop();" onmouseout="this.start();"><div runat="server" id="divWelcomeMessage" clientidmode="Static"></div></marquee>
                    </div>
                </div>
            </div>

            <div class="row">
                
            </div>
            <div class="row">
                <div runat="server" id="divWelcomeLabels" class="col-md-20">
                    <div class="row well span3">
                        <div class="col-md-5"></div>
                        <div class="col-md-5">
                            <img id="img" src="Images/tenwek.jpg" />
                        </div>
                        <div class="col-md-14" style="background-color: cornflowerblue; text-align: center">
                            <font style="font-family: ITC Garamond, georgia, arial; font-size: 24px; color: aliceblue; font-weight: bold;">Tenwek Hospital Notice Board</font>
                            <br />
                            <font style="font-family: ITC Garamond, georgia, arial; font-size: 24px; color: aliceblue; font-weight: bold;">We Treat ~ Jesus Heals</font>
                        </div>

                    </div>
                    <div class="row well span3" style="display: none">
                        <div class="col-md-5">
                            <asp:Label ID="lblcreatedDate" runat="server"></asp:Label>
                        </div>
                        <div class="col-md-19">
                            <asp:Label ID="lblMessage" runat="server" Text=""></asp:Label>
                            <br />
                            <br />


                            <asp:Image ID="ImgProfilePic" Style="width: 731px; height: 816px;" runat="server" Visible="false" />
                        </div>
                    </div>


                    <div class="row well span3" style="padding:5px;background:#91deccab">
                        <div class="row">
                            <div class="col-md-3" style="font-weight: bolder">Subject :</div>
                            <div class="col-md-12" id="divSuject" style="font-weight: bolder;color:blue"></div>
                            <div class="col-md-3" style="font-weight: bolder">News Date :</div>
                            <div class="col-md-6" id="divNewsDate" style="font-weight: bolder;color:blue"></div>
                        </div>
                    </div>
                    <div class="row well span3" style="background-color:#b0c3ccde">                       
                        
                        <div class="row" id="divManagement">
                        </div>

                    </div>


                </div>
                <div class="col-md-4">

                    <div style="font-size: 11px;" class="well span3 top-block">
                        <span class="icon32 icon-color icon-user"></span>
                        <div><span class="icon icon-color icon-clock"></span>Last Login Time</div>
                        <div runat="server" id="divLastLoginTime" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-globe"></span>Last Login IP Address</div>
                        <div runat="server" id="divLastLoginIPAddress" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-users"></span>Total Login Attempts</div>
                        <div runat="server" id="divTotalLogin" style="text-decoration: underline; color: blue"></div>
                        <div><span class="icon icon-color icon-wrench"></span>Last Password Change</div>
                        <div runat="server" id="divLastPasswordChange" style="text-decoration: underline; color: blue"></div>
                        <div runat="server" id="divBatchNumber" style="text-decoration: underline; color: blue"></div>
                        <span class="notification green">0</span>
                        <button type="button" id="btnclosebatch" style="height: 20px; width: 100px; color: white; margin-left: 33px; display: none" onclick="return CheckConfirm()" title="Click To Close Opened Batch" tabindex="6">Close Batch</button>
                    </div>

                    <div style="font-size: 11px;" class="well span3 top-block">
                        <div class="row" style="font-weight: bolder">Recent News</div>
                        <div class="row">
                            <div id="divRecentNews" class="col-md-24" style="overflow-y:auto;overflow-x:auto; height: 150px; display: none">

                                <table id="tblRecent" style="width: 250px;">
                                    <tbody>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <asp:TextBox ID="txtNewsDate" runat="server" ClientIDMode="Static" TabIndex="4" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="calfrom" TargetControlID="txtNewsDate" Format="dd-MMM-yyyy"
                                    Animated="true" runat="server">
                                </cc1:CalendarExtender>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-24">
                                <input type="button" id="btnViewNews" value="View"  onclick="SearchNewsByDate()"  />
                            </div>

                        </div>
                    </div>
                </div>


            </div>


        </div>
    </div>


    <script type="text/javascript">


 

        function SearchData() {
            serverCall('Welcome.aspx/GetDataToFill', {}, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    $('#divSuject').empty();
                    $('#divManagement').empty();
                    $('#divNewsDate').empty();
                    $('#tblRecent').empty();
                    $.each(data, function (i, item) {
                        var IsShow = 0;

                        if (IsShow == 0 && item.IsExpired == 0) {
                            IsShow = 1;
                            $('#divSuject').append(item.Subject);
                            $('#divNewsDate').append(item.NewsDates, ' ', item.NewsTimes);
                            var img = "";

                            if (item.IsAcpture == 1) {
                              
                                img += '<div class="row"> '
                                img += '<div class="col-md-24" id="divDescription">' + item.Description + '</div>';
                                img += '  </div> <div class="row">'
                                img+=     '<div class="col-md-4"></div>'
                                img += ' <div class="col-md-16" id="divAttachment"> <img src=' + item.Attachment + ' id="imgAttachment" style="height: 839px; width:683px;border: 1px solid green" />  </div>';
                                img += '<div class="col-md-4"></div>'
                                img += '</div>';

                            }
                            else {
                                img += '<div class="row"> '
                                img += '<div class="col-md-24" id="divDescription">' + item.Description + '</div>';
                                img += '</div>';
                            }


                            $('#divManagement').append(img);
                        }


                        var rdb = "";
                        rdb += '<tr>';

                        rdb += '<td  style="display:none"> <lable id="lblId">' + item.Id + '</lable> </td>';
                        rdb += '<td >  <div onclick="AppendNews(this)" style="color:blue;cursor:pointer;text-anchor:end;text-decoration:underline;text-align:left;font-size:12px"><lable id="lblsubject">  ' + item.Subject + '</lable></div>  </td>';
                        rdb += '<td   style="display:none"> <lable id="lblNewsDates">' + item.NewsDates + '</lable></td>';
                        rdb += '<td   style="display:none"> <lable id="lblNewsTime">' + item.NewsTimes + '</lable></td>';
                        rdb += '<td  style="display:none"> <lable id="lblDiscription">' + item.Description + '</lable> </td>';
                        rdb += '<td  style="display:none>   <img id="tdimgAttachment"  style="height:100px;  border: 1px solid green" src=' + item.Attachment + '/> </td>';
                        rdb += '<td   style="display:none"> <lable id="lblIsCapture">' + item.IsAcpture + '</lable> </td>';
                        rdb += '<td   style="display:none"> <lable id="lblAttachment">' + item.Attachment + '</lable> </td>';

                        rdb += '</tr> ';
                        $('#tblRecent').append(rdb);



                        HideShow(1);


                    });


                } else {
                    HideShow(0);
                }
            });
        }



        function SearchNewsByDate() {
            var NewsDate = $('#txtNewsDate').val();

            serverCall('Welcome.aspx/GetDataToFillByDate', {Date:NewsDate}, function (response) {

                var GetData = JSON.parse(response);

                if (GetData.status) {

                    data = GetData.data;
                    $('#divSuject').empty();
                    $('#divManagement').empty();
                    $('#divNewsDate').empty();
                    $('#tblRecent').empty();
                    $.each(data, function (i, item) {

                        if (i == 0) {
                            $('#divSuject').append(item.Subject);
                            $('#divNewsDate').append(item.NewsDates, ' ', item.NewsTimes);
                            var img = "";

                            if (item.IsAcpture == 1) {
                                img += '<div class="row"> '
                                img += '<div class="col-md-24" id="divDescription">' + item.Description + '</div>';
                                img += '  </div> <div class="row">'
                                img += '<div class="col-md-4"></div>'
                                img += ' <div class="col-md-16" id="divAttachment"> <img src=' + item.Attachment + ' id="imgAttachment" style="height: 839px; width:683px;border: 1px solid green" />  </div>';
                                img += '<div class="col-md-4"></div>'
                                img += '</div>';

                            }
                            else {
                                img += '<div class="row"> '
                                img += '<div class="col-md-24" id="divDescription">' + item.Description + '</div>';
                                img += '</div>';
                            }


                            $('#divManagement').append(img);
                        }


                        var rdb = "";
                        rdb += '<tr>';

                        rdb += '<td  style="display:none"> <lable id="lblId">' + item.Id + '</lable> </td>';
                        rdb += '<td >  <div onclick="AppendNews(this)" style="color:blue;cursor:pointer;text-anchor:end;text-decoration:underline;text-align:left;font-size:12px"><lable id="lblsubject">  ' + item.Subject + '</lable></div>  </td>';
                        rdb += '<td   style="display:none"> <lable id="lblNewsDates">' + item.NewsDates + '</lable></td>';
                        rdb += '<td   style="display:none"> <lable id="lblNewsTime">' + item.NewsTimes + '</lable></td>';
                        rdb += '<td  style="display:none"> <lable id="lblDiscription">' + item.Description + '</lable> </td>';
                        rdb += '<td  style="display:none>   <img id="tdimgAttachment"  style="height: 100px; border: 1px solid green" src=' + item.Attachment + '/> </td>';
                        rdb += '<td   style="display:none"> <lable id="lblIsCapture">' + item.IsAcpture + '</lable> </td>';
                        rdb += '<td   style="display:none"> <lable id="lblAttachment">' + item.Attachment + '</lable> </td>';

                        rdb += '</tr> ';
                        $('#tblRecent').append(rdb);



                        HideShow(1);


                    });


                } else {
                    HideShow(0);
                }
            });
        }








        function AppendNews(rowid) {

            $('#divSuject').empty();
            $('#divManagement').empty();
            $('#divNewsDate').empty();
            var CurrentId = $(rowid).closest('tr').find("#lblId").text();
            var Discription = $(rowid).closest('tr').find("#lblDiscription").html() ;
            var Subject = $(rowid).closest('tr').find("#lblsubject").text();
            var Date = $(rowid).closest('tr').find("#lblNewsDates").text();
            var NewsTime = $(rowid).closest('tr').find("#lblNewsTime").text();
           // var Attachment = $(rowid).closest('tr').find("#tdimgAttachment").prop('src');
            var IsCapture = $(rowid).closest('tr').find("#lblIsCapture").text();
            var Attachment = $(rowid).closest('tr').find("#lblAttachment").text();
             
            $('#divSuject').append(Subject);
            $('#divNewsDate').append(Date, ' ', NewsTime);
            var img = "";

            if (IsCapture == 1) {

                img += '<div class="row"> '
                img += '<div class="col-md-24" id="divDescription">' + Discription + '</div>';
                img += '  </div> <div class="row">'
                img+='<div class="col-md-4"></div>'
                img += ' <div class="col-md-16" id="divAttachment"> <img src=' + Attachment + ' id="imgAttachment" style="height: 839px; width:683px;border: 1px solid green" />  </div>';
                img += '<div class="col-md-4"></div>'
                img += '</div>';
            }
            else {
                img += '<div class="row"> '
                img += '<div class="col-md-24" id="divDescription">' + Discription + '</div>';
                img += '</div>';
            }


            $('#divManagement').append(img);
        }
   

        function HideShow(Type) {

            if (Type == 0) {
                $("#divRecentNews").hide();
            } else {
                $("#divRecentNews").show();
            }

        }
        
         
            $(function () {
                $('imgAttachment').click(function (e) {
                    e.preventDefault();
                    var imageWin;
                    var imageUrl = $.trim($(this).attr('src')),
                        imageWin = window.open(imageUrl);

                });
            });
        
            function OpenImage(src) {
                var image = new Image();
                image.src = src;

                var w = window.open("");
                w.document.write(image.outerHTML);
            }
        </script>
</asp:Content>
