# Dockerfile - this is a comment. Delete me if you want.
FROM python
COPY . /app
WORKDIR /app
RUN pip install pip --upgrade
RUN pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org -r requirements.txt
EXPOSE 5000
ENTRYPOINT ["python"]
CMD ["app.py"]